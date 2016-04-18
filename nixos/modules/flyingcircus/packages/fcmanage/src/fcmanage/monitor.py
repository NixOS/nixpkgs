"""Manages local Sensu monitoring checks"""

import argparse
import datetime
import json
import shlex
import socket
import sys
import urllib.parse
import xmlrpc.client


def get_directory(enc, url):
    user = socket.gethostname()
    password = enc['parameters']['directory_password']
    parts = urllib.parse.urlsplit(url)
    if not socket.getdefaulttimeout():
        socket.setdefaulttimeout(300)
    return xmlrpc.client.ServerProxy('%s://%s:%s@%s%s' % (
        parts.scheme, user, password, parts.netloc, parts.path))


def get_sensucheck_configuration(servicechecks):
    checks = {}
    result = {'checks': checks}

    for servicecheck in servicechecks:
        name = 'directory.servicecheck.{rg}.{id}'.format(
            rg=servicecheck['resource_group'],
            id=servicecheck['id'])

        url = urllib.parse.urlsplit(servicecheck['url'])
        path = '?'.join([p for p in [url.path, url.query] if p])

        command = [
            'check_http',
            '-H', shlex.quote(url.hostname)]
        if url.port:
            command.extend(['-p', str(url.port)])
        if path:
            command.extend(['-u', shlex.quote(path)])
        if url.scheme == 'https':
            command.append('-S')
        checks[name] = dict(
            command=' '.join(command),
            interval=120,
            subscribers='default',
            handler='directory',
            type='metric',
            check_id=servicecheck['id'],
            standalone=True)

    return result


def write_checks(directory=None, config_file=None, **kw):
    servicechecks = directory.list_servicechecks()
    sensu_checks = get_sensucheck_configuration(servicechecks)

    try:
        with open(config_file, 'r') as f:
            old_check_configuration = json.load(f)
    except IOError:
        old_check_configuration = None
    if old_check_configuration != sensu_checks:
        with open(config_file, 'w') as f:
            json.dump(sensu_checks, f, indent=2, sort_keys=True)


def handle_result(directory=None, enc=None, **kw):
    result = json.load(sys.stdin)
    check = result['check']
    # XXX We should aggregate multiple results into one call.
    directory.register_servicecheck_results([
        dict(
            id=check['check_id'],
            result=check['output'],
            state=check['status'],
            last_check=datetime.datetime.fromtimestamp(
                check['executed']).isoformat())])


def main():
    parser = argparse.ArgumentParser(description='Flying Circus Monitoring')
    parser.add_argument('-E', '--enc', default='/etc/nixos/enc.json',
                        help='Path to enc.json (default: %(default)s)')
    subparsers = parser.add_subparsers(help='sub-command help',
                                       dest='subparser_name')

    checks_parser = subparsers.add_parser('configure-checks')
    checks_parser.set_defaults(func=write_checks)
    checks_parser.add_argument(
        '-c', '--config-file',
        help='Where to put the check configuration (default: %(default)s)',
        default='/etc/local/sensu-client/directory_servicechecks.json')

    result_parser = subparsers.add_parser('handle-result')
    result_parser.set_defaults(func=handle_result)

    args = parser.parse_args()
    if not args.subparser_name:
        parser.print_usage()
        parser.exit("No command given.")

    with open(args.enc) as f:
        enc = json.load(f)
    directory = get_directory(
        enc,
        'https://directory.fcio.net/v2/api')  # RING0
    kw = vars(args)
    kw.pop('enc', None)

    args.func(directory=directory, enc=enc, **kw)

if __name__ == '__main__':
    main()
