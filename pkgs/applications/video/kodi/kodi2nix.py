#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Packages.requests nix unzip

# NOTE: heavy work in progress

import gzip
import requests
import subprocess
import sys
from xml.etree import ElementTree

# TODO: many repositories offer the same plugin with multiple versions... pick latest and don't include duplicates

def format_long_description(value):
  result = ''

  lines = value.strip().splitlines()

  for i, line in enumerate(lines):
    if i == 0:
      result += "        {}".format(line)
    else:
      result += "\n        {}".format(line)

  return result


def parse_addon(root, datadir=None):
  id = root.get('id')
  name = root.get('name')
  version = root.get('version')

  # prepare some nix specific values
  namespace = id
  plugin = id.replace('.', '-').replace('@', '_at_')

  isPython = False

  for child in root.iter('extension'):
    point = child.get('point')

    if point == 'xbmc.python.module':
      isPython = True
      continue

    # we don't want to create a nix expression for kodi repositories...
    # instead we want to create a nix expression for every addon within a repository
    if point == 'xbmc.addon.repository':
      # TODO: figure out all the permutations of the attributes in these values
      info = child.findtext('info')
      checksum = child.findtext('checksum')
      datadir = child.findtext('datadir')

      # TODO: cache the result of this `requests.get`
      request = requests.get(info)
      #with gzip.open('addons.xml.gz','r') as f:
      #  data = f.read()

      if info.endswith('.xml.gz'):
        data = gzip.decompress(request.content)
      else:
        data = request.content

      data = data.decode('utf-8')

      tree = ElementTree.fromstring(data)

      for t in tree.iter('addon'):
        parse_addon(t, datadir=datadir)

      return

    if point == 'xbmc.addon.metadata' or point == 'kodi.addon.metadata':

      platform = child.findtext('platform', 'all')

      if platform != 'all':
        # skip binary addons, we'll have to manually create nix expressions for those
        continue

      path = child.findtext('path')
      source = child.findtext('source') # TODO: do something with this... sometimes 'path' doesn't exist (in other repos)
      license = child.findtext('license') # TODO: map to nixos licenses
      website = child.findtext('website')
      description = child.findtext('./description[@lang="en_GB"]') or child.findtext('./description[@lang="en_US"]') or child.findtext('./description[@lang="en"]') # oh boy... i should learn some xpath

      if isPython:
        print('  %s = python3Packages.toPythonModule (mkKodiPlugin {' % (plugin))
      else:
        print('  %s = mkKodiPlugin {' % (plugin))
      print('    plugin = "%s";' % (plugin))
      print('    namespace = "%s";' % (namespace))
      print('    version = "%s";' % (version))
      # TODO: path vs source logic
      print('    src = fetchzip {')
      print('      url = "%s/%s";' % (datadir, path))
      # TODO: handle failure
      print('      sha256 = "%s";' % (subprocess.run(['nix-prefetch-url', '--unpack', (datadir + '/' + path)], stdout=subprocess.PIPE, stderr=subprocess.DEVNULL).stdout.decode('utf-8').strip()))
      print('    };')

      # print('found addon: %s version %s' % (id, version))
      # print('  platform = %s, path = %s, source = %s, license: %s, website: %s, description: %s' % (platform, path, source, license, website, description))

      print('    propagatedBuildInputs = [')

      for req in root.findall('./requires/import'):
        addon = req.get('addon').replace('.', '-').replace('@', '_at_')
        version = req.get('version')
        optional = req.get('optional', 'n/a')

        if optional == "true":
          # there aren't many optional dependencies and sometimes they try to pull in binary builds
          continue;

        # TODO: would be nice to handle req.get('version') here...
        print('      %s # version %s' % (addon, version))

      print('    ];')
      print('    meta = with lib; {')
      # TODO: make a generic description based on the <addon name=?> -> "Kodi plugin: %s"
      print('      description = "Kodi addon: %s";' % (name))
      if description is not None:
        print("      longDescription = ''")
        print(format_long_description(description))
        print("      '';")
      if website is not None: print('      homepage = "%s";' % (website))
      # TODO: license mapping
      print('      platform = platforms.all;')
      print('    };')
      if isPython:
        print('  });', flush=True);
      else:
        print('  };', flush=True);

      return

addonXml = sys.argv[1]

if not addonXml.endswith('addon.xml'):
  print('Usage: %s addon.xml' % (sys.argv[0]))
  exit(1)

# tree = ElementTree.parse('/nix/store/7y2x9nczh8vz440v8wciii8nwiqj0l1c-kodi-with-plugins-19.0/share/kodi/addons/repository.xbmc.org/addon.xml')
tree = ElementTree.parse(addonXml)

print('{ lib, newScope, fetchzip, python3Packages }:')
print('lib.makeScope newScope (self: with self; {')

parse_addon(tree.getroot())

print('})')
