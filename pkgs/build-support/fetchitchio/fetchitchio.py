import itertools
import json
import os
import platform
import shutil
import sys
import urllib.error
import urllib.parse
import urllib.request

with open(os.environ['NIX_ATTRS_JSON_FILE']) as env_file:
    ENV = json.load(env_file)

USER_AGENT = f'Python/{platform.python_version()} Nixpkgs/{ENV['nixpkgsVersion']}'
TIMEOUT = float(os.environ.get('NIX_CONNECT_TIMEOUT') or '15')

ENDPOINT = ENV['endpoint']
GAME_URL = ENV['gameUrl']
UPLOAD_ID = ENV['upload']

def abort(message):
    if 'extraMessage' in ENV:
        message = f'{message} {ENV['extraMessage']}'
    print(message, file=sys.stderr)
    sys.exit(1)

try:
    API_KEY = os.environ[ENV['apiKeyVar']]
except KeyError:
    abort(
        f'Either set {ENV['apiKeyVar']} for the nix building process '
        f'or manually download {ENV.get('uploadName', 'the required file')} '
        f'from {GAME_URL} and add it to nix store.'
    )

def urlopen(url_or_request):
    return urllib.request.urlopen(url_or_request, timeout=TIMEOUT)

with urlopen(f'{GAME_URL}/data.json') as response:
    data = json.load(response)
    GAME_ID = data['id']
    IS_FREE = 'price' not in data

def api(path, params={}, download=False):
    url = f'{ENDPOINT}{path}?{urllib.parse.urlencode({'api_key': API_KEY, **params})}'
    if download and ENV['showUrl']:
        with open(os.environ['out'], 'w') as output_file:
            print(url, file=output_file)
        return
    request = urllib.request.Request(url, headers={'User-Agent': USER_AGENT})
    with urlopen(request) as response:
        if download:
            with open(os.environ['out'], 'wb') as output_file:
                shutil.copyfileobj(response, output_file)
        else:
            return json.load(response)

if IS_FREE:
    api(f'/uploads/{UPLOAD_ID}/download', download=True)
    sys.exit()

KEY_ID = None
for page in itertools.count(1):
    data = api('/profile/owned-keys', {'page': page})
    if 'owned_keys' not in data:
        break
    for key in data['owned_keys']:
        if key['game_id'] == GAME_ID:
            KEY_ID = key['id']
            break
    if len(data['owned_keys']) < data['per_page']:
        break
if not KEY_ID:
    abort(f'Cannot find a key associated with {GAME_URL}. Did you buy the game?')

api(f'/uploads/{UPLOAD_ID}/download', {'download_key_id': KEY_ID}, download=True)
