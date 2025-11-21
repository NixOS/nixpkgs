#!/usr/bin/env python3

"""
Converts the LibreOffice `download.lst` file into a Nix expression.

Requires an environment variable named `downloadList` identifying the path
of the input file, and writes the result to stdout.

todo - Ideally we would move as much as possible into derivation dependencies.
"""
import collections, itertools, json, re, subprocess, sys, os
import urllib.request, urllib.error

def main():

    packages = list(get_packages())

    for x in packages:
        print(x, file=sys.stderr)

    print('[')

    for x in packages:

        md5 = x['md5']
        upstream_sha256 = x['sha256']
        if upstream_sha256:
            hash = upstream_sha256
            hashtype = 'sha256'
        else:
            hash = md5
            hashtype = 'md5'
        tarball = x['tarball']

        url = construct_url(x)
        print('url: {}'.format(url), file=sys.stderr)

        path = download(url, tarball, hash, hashtype)
        print('path: {}'.format(path), file=sys.stderr)

        sha256 = get_sha256(path)
        print('sha256: {}'.format(sha256), file=sys.stderr)

        print('  {')
        print('    name = "{}";'.format(tarball))
        print('    url = "{}";'.format(url))
        print('    sha256 = "{}";'.format(sha256))
        print('    md5 = "{}";'.format(md5))
        print('    md5name = "{}-{}";'.format(md5 or upstream_sha256,tarball))
        print('  }')

    print(']')


def construct_url(x):
    if x['brief']:
        url = 'https://dev-www.libreoffice.org/src/{}{}'.format(
            x.get('subdir', ''), x['tarball'])
    else:
        url = 'https://dev-www.libreoffice.org/src/{}{}-{}'.format(
            x.get('subdir', ''), x['md5'], x['tarball'])

    if x['name'].startswith('FONT_NOTO_') and not probe_url(url):
        return 'https://noto-website-2.storage.googleapis.com/pkgs/{}'.format(x['tarball'])

    if x['name'] == 'FONT_OPENDYSLEXIC':
        return 'https://github.com/antijingoist/opendyslexic/releases/download/v0.91.12/{}'.format(x['tarball'])

    return url


def probe_url(url: str) -> bool:
    request = urllib.request.Request(url, method='HEAD')
    try:
        with urllib.request.urlopen(request) as response:
            return response.status == 200
    except urllib.error.HTTPError as e:
        return False


def download(url, name, hash, hashtype):
    cmd = ['nix-prefetch-url', url, hash, '--print-path',
           '--type', hashtype, '--name', name]
    proc = subprocess.run(cmd, stdout=subprocess.PIPE, check=True,
                          universal_newlines=True)
    return proc.stdout.split('\n')[1].strip()


def get_sha256(path):
    cmd = ['sha256sum', path]
    proc = subprocess.run(cmd, stdout=subprocess.PIPE, check=True,
                          universal_newlines=True)
    return proc.stdout.split(' ')[0].strip()


def get_packages():
    """
    All of the package data: What's parsed from download.lst,
    plus our additions.
    """
    return apply_additions(get_packages_from_download_list(),
                           get_additions())


def get_additions():
    """
    A mapping from package name (the all-caps identifiers used in
    `download.lst`) to a dict of additional attributes to set on the package.
    """
    with open('./libreoffice-srcs-additions.json') as f:
        return json.load(f)


def apply_additions(xs, additions):
    for x in xs:
        yield dict_merge([x,
                          additions.get(x['name'], {})])


def get_packages_from_download_list():
    """
    The result of parsing `download.lst`: A list of dicts containing keys
    'name', 'tarball', 'md5', 'brief'.
    """

    def lines():
        for x in sub_symbols(parse_lines(get_lines())):

            interpretation = interpret(x)

            if interpretation == 'unrecognized':
                print_skipped_line(x)
            else:
                yield dict_merge([x,
                                  interpretation])

    def cluster(xs):
        """
        Groups lines according to their order within the file, to support
        packages that are listed in `download.lst` more than once.
        """
        keys = ['tarball', 'md5', 'sha256', 'brief']
        a = {k: [x for x in xs if k in x['attrs']] for k in keys}
        return zip(*[a[k] for k in keys])

    def packages():
        for (name, group) in groupby(lines(), lambda x: x['name']):
            for xs in cluster(group):
                yield {'name': name,
                       'attrs': dict_merge(x['attrs'] for x in xs),
                       'index': min(x['index'] for x in xs)}

    for x in sorted(packages(), key=lambda x: x['index']):
        yield dict_merge([{'name': x['name']},
                          x['attrs']])


def dict_merge(xs):
    """
    >>> dict_merge([{1: 2}, {3: 4}, {3: 5}])
    {1: 2, 3: 4}
    """
    return dict(collections.ChainMap(*xs))


def groupby(xs, f):
    """
    >>> groupby([1, 2, 3, 4], lambda x: x % 2)
    [(0, [2, 4]), (1, [1, 3])]
    """
    for (k, iter) in itertools.groupby(sorted(xs, key=f), f):
        group = list(iter)
        yield (f(group[0]), group)


def get_lines():

    download_list = os.getenv('downloadList')

    with open(download_list) as f:
        return f.read().splitlines()


def print_skipped_line(x):

    print('Skipped line {}: {}'.format(x['index'],
                                       x['original']),
          file=sys.stderr)


def parse_lines(lines):
    """
    Input: List of strings (the lines from `download.lst`
    Output: Iterator of dicts with keys 'key', 'value', and 'index'
    """
    for (index, line) in enumerate(lines):

        x = { 'index': index, 'original': line }

        result = parse_line(line)

        if result == 'nothing':
            pass
        elif result == 'unrecognized':
            print_skipped_line(x)
        else:
            yield dict_merge([x,
                             result])


def parse_line(line):
    """
    Input: A string
    Output: One of 1. A dict with keys 'key', 'value'
                   2. 'nothing' (if the line contains no information)
                   2. 'unrecognized' (if parsing failed)
    """

    if re.match('\s*(#.*)?$', line):
        return 'nothing'

    match = re.match('([^:\s]+)\s*:=\s*(.*)$', line)

    if match:
        return {
            'key': match.group(1),
            'value': match.group(2).strip()
        }
    else:
        return 'unrecognized'


def sub_symbols(xs):
    """
    Do substitution of variables across all lines.

    >>> sub_symbols([{'key': 'a', 'value': 'x'},
    ...              {'key': 'c': 'value': '$(a)yz'}])
    [{'key': 'a', 'value': 'x'}, {'key': 'c': 'value': 'xyz'}]
    """

    xs = list(xs)

    symbols = {x['key']: x for x in xs}

    def get_value(k):
        x = symbols.get(k)
        return x['value'] if x is not None else ''

    for x in xs:
        yield dict_merge([{'value': sub_str(x['value'], get_value)},
                          x])


def sub_str(string, func):
    """
    Do substitution of variables in a single line.

    >>> sub_str("x = $(x)", lambda k: {'x': 'a'}[k])
    "x = a"
    """

    def func2(m):
        x = m.group(1)
        result = func(x)
        return result if result is not None else x

    return re.sub(r'\$\(([^\$\(\)]+)\)', func2, string)


def interpret(x):
    """
    Input: Dict with keys 'key' and 'value'
    Output: One of 1. Dict with keys 'name' and 'attrs'
                   2. 'unrecognized' (if interpretation failed)
    """
    for f in [interpret_md5, interpret_sha256, interpret_tarball_with_md5, interpret_tarball, interpret_jar]:
        result = f(x)
        if result is not None:
            return result

    return 'unrecognized'


def interpret_md5(x):
    """
    >>> interpret_md5("ODFGEN_MD5SUM", "32572ea48d9021bbd6fa317ddb697abc")
    {'name': 'ODFGEN', 'attrs': {'md5': '32572ea48d9021bbd6fa317ddb697abc'}}
    """

    match = re.match('^(.*)_MD5SUM$', x['key'])

    if match:
        return {'name': match.group(1),
                'attrs': {'md5': x['value'], 'sha256': ''}}

def interpret_sha256(x):
    match = re.match('^(.*)_SHA256SUM$', x['key'])

    if match:
        return {'name': match.group(1),
                'attrs': {'sha256': x['value'], 'md5': ''}}

def interpret_tarball(x):
    """
    >>> interpret_tarball("FREEHAND_TARBALL", "libfreehand-0.1.1.tar.bz2")
    {'name': 'FREEHAND',
     'attrs': {'tarball': 'libfreehand-0.1.1.tar.bz2', 'brief': True}}
    """

    match = re.match('^(.*)_TARBALL$', x['key'])

    if match:
        return {'name': match.group(1),
                'attrs': {'tarball': x['value'], 'brief': True}}

def interpret_jar(x):
    match = re.match('^(.*)_JAR$', x['key'])

    if match:
        return {'name': match.group(1),
                'attrs': {'tarball': x['value'], 'brief': True}}


def interpret_tarball_with_md5(x):
    """
    >>> interpret_tarball_with_md5("CLUCENE_TARBALL",\
        "48d647fbd8ef8889e5a7f422c1bfda94-clucene-core-2.3.3.4.tar.gz")
    {'name': 'CLUCENE',
     'attrs': {'tarball': 'clucene-core-2.3.3.4.tar.gz',
               'md5': '48d647fbd8ef8889e5a7f422c1bfda94', 'brief': False}}
    """

    match = {'key': re.match('^(.*)_(TARBALL|JAR)$', x['key']),
             'value': re.match('(?P<md5>[0-9a-fA-F]{32})-(?P<tarball>.+)$',
                               x['value'])}

    if match['key'] and match['value']:
        return {'name': match['key'].group(1),
                'attrs': {'tarball': match['value'].group('tarball'),
                          'md5': match['value'].group('md5'),
                          'sha256': '',
                          'brief': False}}


main()
