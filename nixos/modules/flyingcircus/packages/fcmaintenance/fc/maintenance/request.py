from .estimate import Estimate
from .state import State, evaluate_state

import contextlib
import datetime
import iso8601
import os
import os.path as p
import pytz
import shortuuid
import tempfile
import yaml


def utcnow():
    return pytz.utc.localize(datetime.datetime.utcnow())


@contextlib.contextmanager
def cd(newdir):
    oldcwd = os.getcwd()
    os.chdir(newdir)
    try:
        yield
    finally:
        os.chdir(oldcwd)


class Request:

    MAX_RETRIES = 48

    _reqid = None
    activity = None
    comment = None
    estimate = None
    next_due = None
    state = State.pending
    dir = None

    def __init__(self, activity, estimate, comment=None, dir=None):
        self.activity = activity
        self.estimate = Estimate(estimate)
        self.comment = comment
        self.dir = dir
        self.attempts = []

    def __str__(self):
        return '{state} {shortid} {sched} {comment}{duration}'.format(
            state=self.state.short, shortid=self.id[:7],
            sched=(self.next_due.strftime('%Y-%m-%d %H:%M UTC')
                   if self.next_due else '--- TBA ---       '),
            comment=self.comment,
            duration=(' (duration: {})'.format(Estimate(self.duration))
                      if self.duration else ''))

    def __eq__(self, other):
        return self.__class__ == other.__class__ and self.id == other.id

    def __hash__(self):
        return hash(self.id)

    def __lt__(self, other):
        if self.next_due and other.next_due:
            return self.next_due < other.next_due
        elif self.next_due:
            return True
        elif other.next_due:
            return False
        else:
            return self.id < other.id

    @property
    def id(self):
        if not self._reqid:
            self._reqid = shortuuid.uuid()
        return self._reqid

    @property
    def duration(self):
        if self.attempts:
            return self.attempts[-1].duration

    @property
    def filename(self):
        return p.join(self.dir, 'request.yaml')

    @classmethod
    def load(cls, dir):
        with open(p.join(dir, 'request.yaml')) as f:
            instance = yaml.load(f)
        instance.dir = dir
        instance.activity.load(dir)
        return instance

    def save(self):
        assert self.dir, 'request directory not set'
        if not p.isdir(self.dir):
            os.mkdir(self.dir)
        with tempfile.NamedTemporaryFile(
                mode='w', dir=self.dir, delete=False) as tf:
            yaml.dump(self, tf)
            tf.flush()
            os.chmod(tf.fileno(), 0o644)
            os.rename(tf.name, self.filename)
        self.activity.dump(dir)

    def execute(self):
        self.state = State.running
        self.save()
        attempt = Attempt()
        with cd(self.dir):
            self.activity.run()
        attempt.record(self.activity)
        self.attempts.append(attempt)
        self.state = evaluate_state(self.activity.returncode)

    def update_due(self, due):
        old = self.next_due
        if not due:
            self.next_due = None
        elif isinstance(due, datetime.datetime):
            self.next_due = due
        else:
            self.next_due = iso8601.parse_date(due)
        return self.next_due != old

    def update_state(self):
        if (self.state in (State.pending, State.postpone) and
                self.next_due and utcnow() >= self.next_due):
            self.state = State.due
        if len(self.attempts) > self.MAX_RETRIES:
            self.state = State.retrylimit
        return self.state


class Attempt:
    """Data object to track finished activities."""

    stdout = None
    stderr = None
    returncode = None
    finished = None

    def __init__(self):
        self.started = utcnow()

    def record(self, activity):
        self.finished = utcnow()
        (self.stdout, self.stderr, self.returncode) = (
            activity.stdout, activity.stderr, activity.returncode)

    @property
    def duration(self):
        if self.started and self.finished:
            return self.finished - self.started
