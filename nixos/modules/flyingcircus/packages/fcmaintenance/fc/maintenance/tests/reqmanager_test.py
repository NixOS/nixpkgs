from fc.maintenance.activity import Activity
from fc.maintenance.reqmanager import ReqManager
from fc.maintenance.request import Request, Attempt
from fc.maintenance.state import State, ARCHIVE, EXIT_POSTPONE

import fc.maintenance.reqmanager

import contextlib
import datetime
import freezegun
import os
import os.path as p
import pytest
import pytz
import shortuuid
import sys
import unittest.mock
import uuid


@pytest.yield_fixture
def reqmanager(tmpdir):
    with ReqManager(str(tmpdir)) as rm:
        yield rm


@contextlib.contextmanager
def request_population(n, dir):
    """Creates a ReqManager with a pregenerated population of N requests.

    The ReqManager and a list of Requests are passed to the calling code.
    """
    with ReqManager(str(dir)) as reqmanager:
        requests = []
        for i in range(n):
            req = Request(Activity(), 60)
            req._reqid = shortuuid.encode(uuid.UUID(int=i))
            reqmanager.add(req)
            requests.append(req)
        yield (reqmanager, requests)


def test_init_should_create_directories(tmpdir):
    spooldir = str(tmpdir / 'maintenance')
    ReqManager(spooldir)
    assert p.isdir(spooldir)
    assert p.isdir(p.join(spooldir, 'requests'))
    assert p.isdir(p.join(spooldir, 'archive'))


def test_lockfile(tmpdir):
    with ReqManager(str(tmpdir)):
        with open(str(tmpdir / '.lock')) as f:
            assert f.read().strip() == str(os.getpid())
    with open(str(tmpdir / '.lock')) as f:
        assert f.read() == ''


def test_req_save(tmpdir):
    with request_population(1, tmpdir) as (rm, requests):
        req = requests[0]
        assert p.isfile(p.join(req.dir, 'request.yaml'))
        print(open(p.join(req.dir, 'request.yaml')).read())


class FunnyActivity(Activity):

    def __init__(self, mood):
        self.mood = mood


def test_scan(tmpdir):
    with request_population(3, tmpdir) as (rm, requests):
        requests[0].comment = 'foo'
        requests[0].save()
        requests[1].activity = FunnyActivity('good')
        requests[1].save()
    with ReqManager(str(tmpdir)) as rm:
        assert set(rm.requests.values()) == set(requests)


def test_scan_invalid(tmpdir):
    os.makedirs(str(tmpdir / 'requests' / 'emptydir'))
    open(str(tmpdir / 'requests' / 'foo'), 'w').close()
    ReqManager(str(tmpdir)).scan()  # should not raise
    assert True


@unittest.mock.patch('fc.util.directory.connect')
def test_schedule_empty(connect, reqmanager):
    rpccall = connect().schedule_maintenance
    reqmanager.schedule()
    rpccall.assert_not_called()


@unittest.mock.patch('fc.util.directory.connect')
def test_schedule_requests(connect, reqmanager):
    req = reqmanager.add(Request(Activity(), 1, 'comment'))
    rpccall = connect().schedule_maintenance
    rpccall.return_value = {req.id: {'time': '2016-04-20T15:12:40.9+00:00'}}
    reqmanager.schedule()
    rpccall.assert_called_once_with({
        req.id: {'estimate': 1, 'comment': 'comment'}})
    assert req.next_due == datetime.datetime(
        2016, 4, 20, 15, 12, 40, 900000, tzinfo=pytz.UTC)


@unittest.mock.patch('fc.util.directory.connect')
def test_delete_disappeared_requests(connect, reqmanager):
    req = reqmanager.add(Request(Activity(), 1, 'comment'))
    sched = connect().schedule_maintenance
    sched.return_value = {
        req.id: {'time': '2016-04-20T15:12:40.9+00:00'},
        '123abc': {'time': None},
    }
    endm = connect().end_maintenance
    reqmanager.schedule()
    endm.assert_called_once_with({'123abc': {'result': 'deleted'}})


@freezegun.freeze_time('2016-04-20 12:00:00')
def test_execute_all_due(tmpdir):
    with request_population(3, tmpdir) as (rm, reqs):
        reqs[0].state = State.running
        reqs[1].state = State.tempfail
        reqs[1].next_due = datetime.datetime(2016, 4, 20, 10, tzinfo=pytz.UTC)
        reqs[2].next_due = datetime.datetime(2016, 4, 20, 11, tzinfo=pytz.UTC)
        rm.execute()
        for r in reqs:
            assert len(r.attempts) == 1


@freezegun.freeze_time('2016-04-20 12:00:00')
def test_execute_not_due(tmpdir):
    with request_population(3, tmpdir) as (rm, reqs):
        reqs[0].state = State.error
        reqs[1].state = State.postpone
        reqs[2].next_due = datetime.datetime(2016, 4, 20, 13, tzinfo=pytz.UTC)
        rm.execute()
        for r in reqs:
            assert len(r.attempts) == 0


class FailingActivity(Activity):

    def run(self):
        raise RuntimeError('error in activity')


def test_execute_logs_exception(reqmanager, caplog):
    req = reqmanager.add(Request(FailingActivity(), 1))
    req.state = State.due
    reqmanager.execute()
    assert 'error in activity' in caplog.text


@unittest.mock.patch('fc.util.directory.connect')
def test_postpone(connect, reqmanager):
    req = reqmanager.add(Request(Activity(), 90))
    req.state = State.postpone
    postp = connect().postpone_maintenance
    reqmanager.postpone()
    postp.assert_called_once_with({req.id: {'postpone_by': 180}})
    assert req.state == State.postpone
    assert req.next_due is None


@unittest.mock.patch('fc.util.directory.connect')
def test_archive(connect, tmpdir):
    endm = connect().end_maintenance
    with request_population(5, tmpdir) as (rm, reqs):
        # len(ARCHIVE) == 4, won't touch the last one in reqs
        for req, state in zip(reqs, sorted(ARCHIVE)):
            req.state = state
            req._reqid = str(state)
            att = Attempt()
            att.duration = 5
            req.attempts = [att]
            req.save()
        rm.archive()
        endm.assert_called_once_with({
            'success': {'duration': 5, 'result': 'success'},
            'error': {'duration': 5, 'result': 'error'},
            'retrylimit': {'duration': 5, 'result': 'retrylimit'},
            'deleted': {'duration': 5, 'result': 'deleted'},
        })
        for r in reqs[0:3]:
            assert 'archive/' in r.dir
        assert 'requests/' in reqs[4].dir


class PostponeActivity(Activity):

    def run(self):
        self.returncode = EXIT_POSTPONE


@freezegun.freeze_time('2016-04-20 12:00:00')
@unittest.mock.patch('fc.util.directory.connect')
def test_end_to_end(connect, tmpdir):
    with request_population(3, tmpdir) as (rm, reqs):
        # 0: due, exec, archive
        # 1: due, exec, postpone
        reqs[1].activity = PostponeActivity()
        reqs[1].save()
        # 2: not due
        # 3: locally deleted, no req object available
    sched = connect().schedule_maintenance
    endm = connect().end_maintenance
    postp = connect().postpone_maintenance
    sched.return_value = {
        reqs[0].id: {'time': '2016-04-20T11:58:00.0+00:00'},
        reqs[1].id: {'time': '2016-04-20T11:59:00.0+00:00'},
        reqs[2].id: {'time': '2016-04-20T12:01:00.0+00:00'},
        'deleted_req': {},
    }
    sys.argv = ['fc-maintenance', '--spooldir', str(tmpdir)]
    fc.maintenance.reqmanager.main()
    assert sched.call_count == 1
    assert endm.call_count == 2  # delete, archive
    assert postp.call_count == 1


def test_list_empty(reqmanager):
    assert '' == str(reqmanager)


def test_list(reqmanager):
    r1 = Request(Activity(), '14m', 'pending request')
    reqmanager.add(r1)
    r2 = Request(Activity(), '2h', 'due request')
    r2.state = State.due
    r2.next_due = datetime.datetime(2016, 4, 20, 12, tzinfo=pytz.UTC)
    reqmanager.add(r2)
    r3 = Request(Activity(), '1m 30s', 'error request')
    r3.state = State.error
    r3.next_due = datetime.datetime(2016, 4, 20, 11, tzinfo=pytz.UTC)
    att = Attempt()
    att.duration = datetime.timedelta(seconds=75)
    att.returncode = 1
    r3.attempts = [att]
    reqmanager.add(r3)
    assert str(reqmanager) == """\
St Id       Scheduled             Estimate  Comment
e  {id3}  2016-04-20 11:00 UTC  1m 30s    error request (duration: 1m 15s)
*  {id2}  2016-04-20 12:00 UTC  2h        due request
-  {id1}  --- TBA ---           14m       pending request\
""".format(id1=r1.id[:7], id2=r2.id[:7], id3=r3.id[:7])
