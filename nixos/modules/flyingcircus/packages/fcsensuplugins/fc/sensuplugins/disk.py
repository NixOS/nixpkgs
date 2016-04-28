#!/usr/bin/env python3
"""Improved disk check.

The main improvements of this check over the stock disk check are a
notion of virtual disk size (instead of always using the physical disk
size as basis), and the implementation of a magic dampening factor
analogous to check_mk.
"""

# XXX keep in sync with fc.platform/puppet/modules/sys_apps/files/check_disk.py

import argparse
import logging
import nagiosplugin
import psutil

_log = logging.getLogger('nagiosplugin')
GB = 1024 * 1024 * 1024


class Disk(nagiosplugin.Resource):
    """Does the actual work of querying space usage."""

    def __init__(self, params):
        self.params = params
        self.mountpoint = params.mountpoint
        self.disksize = params.disksize

    def probe(self):
        usage = psutil.disk_usage(self.mountpoint)
        _log.debug('probe: %r', usage)
        if not self.disksize:
            self.disksize = usage.total / GB
        percent = round(100.0 * float(usage.used) / GB / self.disksize, 1)
        self.params.register_context(self.disksize)
        return nagiosplugin.Metric(
            self.mountpoint, percent, '%', min=0.0, max=100.0)


class Parameters(object):
    """Value object which passes check parameters around."""

    def __init__(self, check, mountpoint, ranges, cap, normsize, magic,
                 disksize=None):
        self.check = check
        self.mountpoint = mountpoint
        self.ranges = ranges  # (warn, crit)
        self.cap = cap  # (warn, crit)
        self.normsize = normsize
        self.magic = magic
        self.disksize = disksize

    def resource_factory(self):
        return Disk(self)

    def register_resource(self):
        self.check.add(self.resource_factory())

    def magic_range(self, range, cap):
        relsize = self.disksize / self.normsize
        effective_size = relsize ** self.magic
        scale = effective_size / relsize
        new_max = round(100.0-(100.0-range.end)*scale, 1)
        new = '{}:{}'.format(range.start, max(new_max, cap))
        _log.debug('magic({}, {}) -> {}'.format(self.disksize, range, new))
        return nagiosplugin.Range(new)

    def context_factory(self, disksize):
        if not self.disksize and disksize:
            self.disksize = disksize
        magic_ranges = (
            self.magic_range(self.ranges[0], self.cap[0]),  # warn
            self.magic_range(self.ranges[1], self.cap[1]),  # crit
        )
        return nagiosplugin.ScalarContext(
            self.mountpoint, *magic_ranges,
            fmt_metric='{name}: {valueunit} of %.1fGiB full' % self.disksize)

    def register_context(self, disksize):
        self.check.add(self.context_factory(disksize))


class Discovery(object):
    """Queries filesystems from the OS, creates Resources and Contexts."""

    def __init__(self, check, args):
        self.check = check
        self.allowed_types = [f.strip() for f in args.fstypes.split(',')]
        self.ranges = (nagiosplugin.Range(args.warning),
                       nagiosplugin.Range(args.critical))
        self.cap = (float(args.min_warning), float(args.min_critical))
        self.normsize = float(args.normsize)
        self.magic = float(args.magic)
        self.filesystems = args.filesystem

    def add_explicit(self):
        seen = set()
        for params in self.filesystems:
            (mp, warn, crit, disksize, normsize, magic) = (
                params.split(',') + [None, None, None, None, None])[0:6]
            seen.add(mp)
            if not warn:
                warn = self.ranges[0]
            if not crit:
                crit = self.ranges[1]
            disksize = float(disksize) if disksize else None
            normsize = float(normsize) if normsize else self.normsize
            magic = float(magic) if magic else self.magic
            params = Parameters(
                self.check, mp,
                (nagiosplugin.Range(warn), nagiosplugin.Range(crit)),
                self.cap, normsize, magic, disksize)
            params.register_resource()
        return seen

    def add_implicit(self, seen):
        for fs in sorted(psutil.disk_partitions()):
            if fs.fstype not in self.allowed_types:
                continue
            if fs.device in seen or fs.mountpoint in seen:
                continue
            seen.add(fs.device)
            seen.add(fs.mountpoint)
            params = Parameters(self.check, fs.mountpoint, self.ranges,
                                self.cap, self.normsize, self.magic)
            params.register_resource()

    def add_resources(self):
        seen = self.add_explicit()
        self.add_implicit(seen)


class DiskSummary(nagiosplugin.Summary):

    def ok(self, results):
        msg = []
        for r in results:
            msg.append('{}: {}'.format(r.metric.name, r.metric.valueunit))
        return ', '.join(msg)

    def problem(self, results):
        msg = []
        for r in results.most_significant:
            msg.append('{}: {}'.format(r.metric.name, r.metric.valueunit))
        return ', '.join(msg)


@nagiosplugin.guarded
def main():
    a = argparse.ArgumentParser(description=__doc__, epilog="""\
Arguments for individually configured filesystems:
MOUNTPOINT[,WARN[,CRIT[,DISKSIZE[,NORMSIZE[,MAGIC]]]]].  WARN,CRIT - alert
ranges; DISKSIZE - overrides device size; NORMSIZE - individual reference value
for magic calculation; MAGIC - individual magic factor for dampening
calculation.
""")
    a.add_argument('-T', '--fstypes', default='ext4,xfs,btrfs',
                   help='include filesystems of the named types automtically '
                   '(comma-separated, default: %(default)s)')
    a.add_argument('-w', '--warning', metavar='RANGE', default='0:80',
                   help='warning range for automatically configured '
                   'filesystems (default: %(default)s)')
    a.add_argument('-c', '--critical', metavar='RANGE', default='0:90',
                   help='critical range for automatically configured '
                   'filesystems (default: %(default)s)')
    a.add_argument('-m', '--magic', default=0.7, type=float,
                   help='magic dampening factor (default: %(default)s)')
    a.add_argument('-n', '--normsize', metavar='GB', default=30.0, type=float,
                   help='reference filesystem size for dampening calculation '
                   '(default: %(default)s)')
    a.add_argument('-W', '--min-warning', metavar='PERCENT', default='50',
                   type=int,
                   help='lowest warning level regardless of magic '
                   'calculation (default: %(default)s)')
    a.add_argument('-C', '--min-critical', metavar='PERCENT', default='60',
                   type=int,
                   help='lowest critical level regardless of magic '
                   'calculation (default: %(default)s)')
    a.add_argument('-f', '--filesystem', action='append', default=[],
                   metavar='FS_ARGS',
                   help='configure individual filesystems (see below for '
                   'FS_ARGS; can be specified several times)')
    a.add_argument('-v', '--verbose', action='count', default=0,
                   help='increase verbosity')
    a.add_argument('-t', '--timeout', metavar='N', default=30, type=int,
                   help='abort check execution after N seconds')
    args = a.parse_args()
    check = nagiosplugin.Check(DiskSummary())
    discovery = Discovery(check, args)
    discovery.add_resources()
    check.main(args.verbose, args.timeout)


if __name__ == '__main__':
    main()
