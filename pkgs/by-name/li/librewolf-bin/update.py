import base64
import json
import urllib.request

INFO_PATH = 'pkgs/by-name/li/librewolf-bin/info.json'


def download_str(url):
    return urllib.request.urlopen(url).read().decode('utf-8')


def read_info():
    with open(INFO_PATH, 'r') as f:
        return json.load(f)


def write_info(info):
    with open(INFO_PATH, 'w') as f:
        json.dump(info, f, indent=4, sort_keys=True)
        f.write('\n')


def sha256_hex_to_sri(hex):
    return 'sha256-' + base64.b64encode(bytes.fromhex(hex)).decode()


def find_link(links, suffix):
    for link in links:
        if link['name'].endswith(suffix):
            return link
    return None


def parse_sha256_file(data):
    sp = data.strip().split()
    if len(sp) != 2:
        raise (Exception('Failed to parse sha256 file'))
    return sha256_hex_to_sri(sp[0])


prev_info = read_info()
next_info = prev_info

latest_url = "https://gitlab.com/api/v4/projects/librewolf-community%2Fbrowser%2Fappimage/releases/permalink/latest"
latest = json.loads(download_str(latest_url))
print(latest)
tag_name = latest['tag_name']
next_info['version'] = tag_name.removeprefix('v')
print(f'tag_name: {tag_name}')
links = latest['assets']['links']

platforms = {'x86_64': 'x86_64-linux', 'aarch64': 'aarch64-linux'}
for (upstream_platform, nixos_platform) in platforms.items():
    sha256_link = find_link(links, f'{upstream_platform}.AppImage.sha256')
    if sha256_link is None:
        raise (Exception(f'No sha256 link found for platform: {upstream_platform}'))
    appimage_link = find_link(links, f'{upstream_platform}.AppImage')
    if appimage_link is None:
        raise (Exception(f'No appimage link found for platform: {upstream_platform}'))
    sha256_file = download_str(sha256_link['url'])
    sha256_sri = parse_sha256_file(sha256_file)
    appimage_url = appimage_link['url']
    print(f'nixos_platform: {nixos_platform}')
    print(f'  sha256: {sha256_sri}')
    print(f'  url: {appimage_url}')
    next_info[nixos_platform] = {'url': appimage_url, 'hash': sha256_sri}

write_info(next_info)
