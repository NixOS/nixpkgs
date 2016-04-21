from fc.maintenance.activity import Activity
from fc.maintenance.request import Request, Attempt
from fc.maintenance.state import State

import datetime


def test_duration():
    r = Request(Activity(), 1)
    a = Attempt()
    a.finished = a.started + datetime.timedelta(seconds=10)
    r.attempts.append(a)
    a = Attempt()
    a.finished = a.started + datetime.timedelta(seconds=5)
    r.attempts.append(a)
    assert r.duration == datetime.timedelta(seconds=5)  # last attempt counts


def test_save_yaml(tmpdir):
    r = Request(Activity(), 10, 'my comment', dir=str(tmpdir))
    assert r.id is not None
    r.save()
    with open(str(tmpdir / 'request.yaml')) as f:
        assert f.read() == """\
!!python/object:fc.maintenance.request.Request
_reqid: {id}
activity: !!python/object:fc.maintenance.activity.Activity {{}}
attempts: []
comment: my comment
dir: {tmpdir}
estimate: !!python/object:fc.maintenance.estimate.Estimate {{value: 10}}
""".format(id=r.id, tmpdir=str(tmpdir))


def test_execute(tmpdir):
    Request.MAX_RETRIES = 3
    r = Request(Activity(), 1, dir=str(tmpdir))
    results = []
    for i in range(Request.MAX_RETRIES + 1):
        r.execute()
        assert len(r.attempts) == i + 1
        r.update_state()
        results.append(r.state)
    assert results[0] == State.success
    assert results[-2] == State.success
    assert results[-1] == State.retrylimit
