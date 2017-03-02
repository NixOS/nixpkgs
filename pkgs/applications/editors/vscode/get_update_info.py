#! /usr/bin/env nix-shell
#! nix-shell -p python3 curl -i python3

from subprocess import run, PIPE
from re import search


# -----------------------------------------------------------------------------------

def unshorten(short_url):
    url = run(
        ['curl', '-w', '"%{url_effective}\n"',
         '-I', '-L', '-s', '-S', short_url, '-o', '/dev/null'],
        stdout=PIPE
    ).stdout.decode('utf8')
    return url.strip('"\n')


def version(url):
    match = search(r'(?<=code-stable-code_)(.*)(?=-)', url)
    return match.group(0)


def revision(url):
    match = search(r'(?<=stable\/)(.*)(?=\/code)', url)
    return match.group(0)


def sha256(url):
    nix_prefetch_output = run(
        ['nix-prefetch-url', url],
        stdout=PIPE,
        stderr=PIPE
    ).stdout.decode('utf8')
    return nix_prefetch_output.split('\n')[-2]


def linux_url_extra(url):
    match = search(r'code-stable-code_\d+\.\d+\.\d+-(.*)_.*\.tar.gz', url)
    return match.group(1)


# -----------------------------------------------------------------------------------

if __name__ == '__main__':
    linux_ia32_url = unshorten('https://vscode-update.azurewebsites.net/latest/linux-ia32/stable')
    linux_x64_url = unshorten('https://vscode-update.azurewebsites.net/latest/linux-x64/stable')
    darwin_url = unshorten('https://vscode-update.azurewebsites.net/latest/darwin/stable')

    print('----------------------------------------------------------------------------')
    print()
    print('version:                {}'.format(version(linux_ia32_url)))
    print('Revision:               {}'.format(revision(linux_ia32_url)))
    print()
    print('----------------------------------------------------------------------------')
    print()
    print('i686-linux sha256:      {}'.format(sha256(linux_ia32_url)))
    print('x86_64-linux sha256:    {}'.format(sha256(linux_x64_url)))
    print('x86_64-darwin sha256:   {}'.format(sha256(darwin_url)))
    print()
    print('--------------------------------------------------------------------------')
    print()
    print('i686-linux url extra:   {}'.format(linux_url_extra(linux_ia32_url)))
    print('x86_64-linux url extra: {}'.format(linux_url_extra(linux_x64_url)))
    print()
    print('--------------------------------------------------------------------------')
