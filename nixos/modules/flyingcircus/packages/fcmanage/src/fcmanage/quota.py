"""Quota-aware df replacement."""

import argparse
import subprocess
import sys


def df():
    a = argparse.ArgumentParser(description=__doc__, add_help=False)
    a.add_argument('files', metavar='FILE', nargs='*',
                   help='show information about the file system on which each '
                   'FILE resides, or all file systems by default')
    a.add_argument('-h', '--human-readable', action='store_const',
                   const='-h', default='',
                   help='print sizes in powers of 1024 (e.g., 1023M)')
    a.add_argument('-i', '--inodes', action='store_const', const='-i',
                   default='',
                   help='list inode information instead of block usage')
    a.add_argument('-N', '--no-headings', action='store_const', const='-i',
                   default='', help='omit the header')
    a.add_argument('--help', default=False, action='store_true',
                   help='show this help screen')
    args = a.parse_args()
    if args.help:
        a.print_help()
        sys.exit(0)

    p = subprocess.Popen(
        ['xfs_quota', '-c', 'df {i} {h} {N} {files}'.format(
            i=args.inodes, h=args.human_readable, N=args.no_headings,
            files=' '.join(args.files))],
        stdout=subprocess.PIPE)
    out, _err = p.communicate()
    out = out.decode()
    # xfs_quota seems to print everything twice (dunno why)
    seen = set()
    for line in out.splitlines():
        if line not in seen:
            print(line)
        seen.add(line)
    sys.exit(p.returncode)


if __name__ == '__main__':
    df()
