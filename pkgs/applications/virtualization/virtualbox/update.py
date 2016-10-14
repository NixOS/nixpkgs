#!/usr/bin/env python3
import os
import re
import json
import urllib.request

from distutils.version import LooseVersion

UPSTREAM_INFO_FILE = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "upstream-info.json"
)


def fetch_latest_version():
    url = "http://download.virtualbox.org/virtualbox/LATEST.TXT"
    return urllib.request.urlopen(url).read().strip().decode()


def load_upstream_info():
    try:
        with open(UPSTREAM_INFO_FILE, 'r') as fp:
            return json.load(fp)
    except FileNotFoundError:
        return {'version': "0"}


def save_upstream_info(contents):
    remark = "Generated using update.py from the same directory."
    contents['__NOTE'] = remark
    data = json.dumps(contents, indent=2, sort_keys=True)
    with open(UPSTREAM_INFO_FILE, 'w') as fp:
        fp.write(data + "\n")


def fetch_file_table(version):
    url = "http://download.virtualbox.org/virtualbox/{}/SHA256SUMS"
    url = url.format(version)
    result = {}
    for line in urllib.request.urlopen(url):
        sha, name = line.rstrip().split()
        result[name.lstrip(b'*').decode()] = sha.decode()
    return result


def update_to_version(version):
    extpack_start = 'Oracle_VM_VirtualBox_Extension_Pack-'
    version_re = version.replace('.', '\\.')
    attribute_map = {
        'extpack': r'^' + extpack_start + r'[^-]+-[^.]+.vbox-extpack$',
        'extpackRev': r'^' + extpack_start + r'[^-]+-([^.]+).vbox-extpack$',
        'main': r'^VirtualBox-' + version_re + r'.tar.bz2$',
        'guest': r'^VBoxGuestAdditions_' + version_re + r'.iso$',
    }
    table = fetch_file_table(version)
    new_attrs = {'version': version}
    for attr, searchexpr in attribute_map.items():
        result = [re.search(searchexpr, key) for key in table.keys()]
        filtered = filter(lambda m: m is not None, result)
        found = [m.groups()[0] if len(m.groups()) > 0 else table[m.group(0)]
                 for m in filtered if m is not None]

        if len(found) == 0:
            msg = "No package found for attribute {}".format(attr)
            raise AssertionError(msg)
        elif len(found) != 1:
            msg = "More than one package found for attribute {}: ".format(attr)
            msg += ', '.join(found)
            raise AssertionError(msg)
        else:
            new_attrs[attr] = found[0]
    return new_attrs


info = load_upstream_info()
latest = fetch_latest_version()
if LooseVersion(info['version']) < LooseVersion(latest):
    print("Updating to version {}...".format(latest), end="", flush=True)
    new_attrs = update_to_version(latest)
    save_upstream_info(new_attrs)
    print(" done.")
else:
    print("Version {} is already the latest one.".format(info['version']))
