#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 common-updater-scripts nix-prefetch-git
import argparse
import base64
import collections
import hashlib
import json
import os
import subprocess
import tempfile
import urllib.request


REGISTRY_ENDPOINT = 'https://devtools-registry.s3.yandex.net'

PLATFORMS_MAP = {
    "x86_64-darwin": "darwin",
    "aarch64-darwin": "darwin-arm64",
    "x86_64-linux": "linux",
    "aarch64-linux": "linux-aarch64",
}


def remote_sha256(url):
    remote = urllib.request.urlopen(url)
    hash = hashlib.sha256()

    while True:
        data = remote.read(4096)

        if not data:
            break

        hash.update(data)

    return base64.b64encode(hash.digest()).decode()


class Tools:
    def __init__(self):
        self.tools = collections.defaultdict(dict)

    def try_add(self, platform, name, resource):
        if not resource.startswith('sbr:'):
            return

        sbr = resource.removeprefix('sbr:')
        url = f'{REGISTRY_ENDPOINT}/{sbr}'
        self.tools[platform][name] = {
            'sbr': sbr,
            'url': url,
            'hash': f'sha256-{remote_sha256(url)}',
        }


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--platforms', nargs='+', required=True)
    parser.add_argument('--targets', nargs='+', required=True)
    parser.add_argument('--repository', required=True)
    parser.add_argument('--output', required=True)
    args = parser.parse_args()

    revision = subprocess.run(
        f"list-git-tags --url={args.repository} | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n1",
        shell=True,
        check=True,
        stdout=subprocess.PIPE,
    ).stdout.decode().splitlines()[0]

    tools = Tools()

    with tempfile.TemporaryDirectory() as tmp:
        subprocess.run(['git', 'clone', "--depth", "1", "--branch", revision, args.repository, tmp], check=True)

        ya = os.path.join(tmp, 'ya')

        resources = json.loads(subprocess.run(
            [ya, 'make', '-G', '-j0'] + args.targets,
            cwd=tmp,
            check=True,
            stdout=subprocess.PIPE,
        ).stdout)['conf']['resources']

        for resource in resources:
            if 'resource' in resource:
                for platform in args.platforms:
                    tools.try_add(platform, resource['pattern'], resource['resource'])
            elif 'resources' in resource:
                for platform in args.platforms:
                    entry = next(filter(lambda platform_resource: platform_resource['platform'].lower() == PLATFORMS_MAP[platform], resource['resources']))
                    tools.try_add(platform, resource['pattern'], entry['resource'])

        for platform in args.platforms:
            resource = subprocess.run(
                [ya, 'tool', 'ymake', '--platform', PLATFORMS_MAP[platform], '--get-resource-id'],
                cwd=tmp,
                check=True,
                stdout=subprocess.PIPE,
            ).stdout.decode().splitlines()[0]
            tools.try_add(platform, 'YMAKE', resource)

        with open(ya, 'r', encoding='utf-8') as f:
            ya_text = f.read()
            ya_map_text = ya_text[ya_text.index('PLATFORM_MAP = ')+15:ya_text.index('# End of mapping')]
            ya_map = eval(ya_map_text, {'REGISTRY_ENDPOINT': REGISTRY_ENDPOINT})

            for platform in args.platforms:
                tools.try_add(platform, 'YA', 'sbr:' + ya_map['data'][PLATFORMS_MAP[platform]]['urls'][0].removeprefix(f'{REGISTRY_ENDPOINT}/'))

    hash = subprocess.run(
        f"nix hash convert --hash-algo sha256 --to sri $(nix-prefetch-git --url {args.repository} --quiet --rev {revision} | jq -r '.sha256')",
        shell=True,
        check=True,
        stdout=subprocess.PIPE,
    ).stdout.decode().splitlines()[0]

    with open(args.output, 'w', encoding='utf-8') as f:
        json.dump(
            {
                'version': revision[1:],
                'hash': hash,
                'tools': tools.tools,
            },
            f,
            indent=2
        )
        f.write('\n')
