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

    def __init__(self, action):
        self.action = action
        # small allowance for VM clock skew
        self.initial_boottime = self.boottime() + 1

    def boottime(self):
        with open('/proc/uptime') as f:
            uptime = float(f.read().split()[0])
        return time.time() - uptime

    def boom(self):
        subprocess.check_call(['systemctl', self.action])
        # We won't be able to pick up the status of this command as systemd
        # terminates our process right away. The request will be finished
        # properly on the next fc.maintenance run.

    def run(self):
        if self.boottime() > self.initial_boottime:
            self.stdout = 'booted\n'
            return
        self.boom()


def main():
    a = argparse.ArgumentParser(description=__doc__)
    a.add_argument('-c', '--comment', metavar='TEXT', default=None,
                   help='announce upcoming reboot with this message')
    a.add_argument('-d', '--spooldir', metavar='DIR', default=DEFAULT_DIR,
                   help='request spool dir (default: %(default)s)')
    a.add_argument('-p', '--poweroff', default=False, action='store_true',
                   help='power off instead of reboot')
    args = a.parse_args()

    action = 'poweroff' if args.poweroff else 'reboot'
    comment = args.comment if args.comment else (
        'Scheduled machine {}'.format(action))
    rm = ReqManager(spooldir=args.spooldir)
    rm.add(Request(RebootActivity(action), 15 * 60, comment=comment))
