"""Manage maintenance requests."""

from .request import Request
from .state import State, ARCHIVE

import argparse
import fc.directory
import fcntl
import glob
import json
import logging
import os
import os.path as p

LOG = logging.getLogger(__name__)
DEFAULT_DIR = '/var/spool/maintenance'


def require_lock(func):
    """Decorator that asserts an open lockfile prior execution."""
    def assert_locked(self, *args, **kwargs):
        assert self.lockfile, 'method {} required lock'.format(func)
        return func(self, *args, **kwargs)
    return assert_locked


def require_directory(func):
    """Decorator that ensures a directory connection is present."""
    def with_directory_connection(self, *args, **kwargs):
        if self.directory is None:
            enc_data = None
            if self.enc_path:
                with open(self.enc_path) as f:
                    enc_data = json.load(f)
            self.directory = fc.directory.connect(enc_data)
        return func(self, *args, **kwargs)
    return with_directory_connection


class ReqManager:
    """Container for Requests."""

    TIMEFMT = '%Y-%m-%d %H:%M:%S %Z'

    directory = None
    lockfile = None

    def __init__(self, spooldir=DEFAULT_DIR, enc_path=None):
        """Initialize ReqManager and create directories if necessary."""
        self.spooldir = spooldir
        self.requestsdir = p.join(self.spooldir, 'requests')
        self.archivedir = p.join(self.spooldir, 'archive')
        for d in (self.spooldir, self.requestsdir, self.archivedir):
            if not p.exists(d):
                os.mkdir(d)
        self.enc_path = enc_path
        self.requests = {}

    def __enter__(self):
        if self.lockfile:
            return self
        self.lockfile = open(p.join(self.spooldir, '.lock'), 'a+')
        fcntl.flock(self.lockfile.fileno(), fcntl.LOCK_EX)
        self.lockfile.seek(0)
        print(os.getpid(), file=self.lockfile)
        self.lockfile.flush()
        self.scan()
        return self

    def __exit__(self, exc_type, exc_value, exc_tb):
        if self.lockfile:
            self.lockfile.truncate(0)
            self.lockfile.close()
        self.lockfile = None

    def __str__(self):
        """Human-readable listing of active maintenance requests."""
        return '\n\n'.join((str(r) for r in self.requests))

    def dir(self, request):
        """Return file system path for request identified by `reqid`."""
        return p.realpath(p.join(self.requestsdir, request.id))

    def scan(self):
        self.requests = {}
        for d in glob.glob(p.join(self.requestsdir, '*')):
            if not p.isdir(d):
                continue
            try:
                req = Request.load(d)
                self.requests[req.id] = req
            except Exception as e:
                LOG.exception('error loading request from %s', d,
                              exc_info=e)

    def add(self, request):
        self.requests[request.id] = request
        request.dir = self.dir(request)
        request.save()
        return request

    @require_lock
    @require_directory
    def schedule(self):
        """Trigger request scheduling on server."""
        if not self.requests:
            return
        schedule_maintenance = {reqid: {
            'estimate': int(req.estimate), 'comment': req.comment}
            for reqid, req in self.requests.items()}
        LOG.debug('scheduling requests: %s', schedule_maintenance)
        result = self.directory.schedule_maintenance(schedule_maintenance)
        deleted_requests = set()
        for key, val in result.items():
            try:
                req = self.requests[key]
                LOG.debug('(req %s) updating request: %s', key, val)
                if req.update_due(val['time']):
                    LOG.info('(req %s) changing start time to %s',
                             req.id, val['time'])
                    req.save()
            except KeyError:
                LOG.warning('(req %s) request disappeared, marking as deleted',
                            key)
                deleted_requests.add(key)
        if deleted_requests:
            self.directory.end_maintenance(
                {key: {'result': 'deleted'} for key in deleted_requests})

    def runnable(self):
        """Generate due Requests in running order."""
        requests = []
        for request in self.requests.values():
            new_state = request.update_state()
            LOG.debug('(req %s) next due: %s', request.id, request.next_due)
            if new_state is State.running:
                yield request
            elif new_state in (State.due, State.tempfail):
                requests.append(request)
        yield from sorted(requests)

    @require_lock
    def execute(self):
        """Process maintenance requests.

        If there is an already active request, run to termination first.
        After that, select the oldest due request as next active request.
        """
        for req in self.runnable():
            LOG.info('(req %s) starting execution', req.id)
            try:
                req.execute()
            except Exception as e:
                LOG.exception('(req %s) error during execution', exc_info=e)
                req.state = State.error
            req.save()
            LOG.debug('(req %s) executed, state %s', req.id, req.state)

    @require_lock
    @require_directory
    def postpone(self):
        """Instructs directory to postpone requests.

        Postponed requests get their new scheduled time with the next
        schedule call.
        """
        postponed = [r for r in self.requests.values()
                     if r.state == State.postpone]
        if not postponed:
            return
        postpone_maintenance = {req.id: {'postpone_by': 2 * int(req.estimate)}
                                for req in postponed}
        LOG.debug('invoking postpone_maintenance(%s)', postpone_maintenance)
        self.directory.postpone_maintenance(postpone_maintenance)
        for req in postponed:
            req.update_due(None)
            req.save()

    @require_lock
    @require_directory
    def archive(self):
        """Move all completed requests to archivedir."""
        archived = [r for r in self.requests.values() if r.state in ARCHIVE]
        if not archived:
            return
        end_maintenance = {
            req.id: {'duration': req.duration, 'result': str(req.state)}
            for req in archived}
        LOG.debug('invoking end_maintenance(%s)', end_maintenance)
        self.directory.end_maintenance(end_maintenance)
        for req in archived:
            LOG.info('(req %s) completed, archiving request', req.id)
            dest = p.join(self.archivedir, req.id)
            os.rename(req.dir, dest)
            req.dir = dest
            req.save()


def main(verbose=False):
    a = argparse.ArgumentParser(description="""\
Schedules, runs, and archives maintenance requests.
""")
    a.add_argument('-v', '--verbose', action='store_true', default=verbose)
    a.add_argument('-s', '--spooldir', metavar='DIR', default=DEFAULT_DIR,
                   help='requests spool dir (default: %(default)s)')
    a.add_argument('-E', '--enc-path', metavar='PATH', default=None,
                   help='full path to enc.json')
    args = a.parse_args()
    logging.basicConfig(level=logging.DEBUG if verbose else logging.INFO)

    with ReqManager(args.spooldir, args.enc_path) as rm:
        rm.schedule()
        rm.execute()
        rm.postpone()
        rm.archive()
