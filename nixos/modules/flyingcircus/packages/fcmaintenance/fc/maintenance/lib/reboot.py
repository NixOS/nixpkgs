"""Scheduled machine reboot.

This activity does nothing if the machine has been booted for another reason in
the time between creation and execution.
"""

from fc.maintenance.activity import Activity
from fc.maintenance.reqmanager import ReqManager, DEFAULT_DIR
from fc.maintenance.request import Request

import argparse
import subprocess
import time


class RebootActivity(Activity):

    started = None

    def __init__(self, action):
        assert action in ['reboot', 'poweroff']
        self.action = action
        try:
            with open('starttime') as f:
                self.started = float(f.read().strip())
        except (IOError, ValueError):
            pass
        # small allowance for VM clock skew
        self.initial_boottime = self.boottime() + 1

    @staticmethod
    def boottime():
        with open('/proc/uptime') as f:
            uptime = float(f.read().split()[0])
        return time.time() - uptime

    def boom(self):
        with open('starttime', 'w') as f:
            print(time.time(), file=f)
        subprocess.check_call(['systemctl', self.action])
        # We won't be able to pick up the return code of this command as
        # systemd terminates our process right away. The request will be
        # finished properly on the next fc.maintenance run. For the same
        # reason, updates for ourself won't be persisted by Request.save().

    def run(self):
        if not self.boottime() > self.initial_boottime:
            self.boom()
            return
        self.stdout = 'booted at {} UTC'.format(
            time.asctime(time.gmtime(self.boottime())))
        self.returncode = 0
        if self.started:
            self.duration = time.time() - self.started


def main():
    a = argparse.ArgumentParser(description=__doc__)
    a.add_argument('-c', '--comment', metavar='TEXT', default=None,
                   help='announce upcoming reboot with this message')
    a.add_argument('-p', '--poweroff', default=False, action='store_true',
                   help='power off instead of reboot')
    a.add_argument('-d', '--spooldir', metavar='DIR', default=DEFAULT_DIR,
                   help='request spool dir (default: %(default)s)')
    args = a.parse_args()

    action = 'poweroff' if args.poweroff else 'reboot'
    comment = args.comment if args.comment else (
        'Scheduled machine {}'.format(action))
    rm = ReqManager(spooldir=args.spooldir)
    rm.add(Request(RebootActivity(action), 10 * 60, comment=comment))
