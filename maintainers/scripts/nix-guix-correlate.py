#!/usr/bin/env python2

'''
A simple script to correlate the JSON package data from Nix and Guix and
compare versions for packages that are the same in both.

Written by Armijn Hemel -- same license as whatever nixpkgs uses
'''

import os, sys, json, httplib, gzip, StringIO

## Guix exports all available packages as JSON
## https://www.gnu.org/software/guix/packages/packages.json
httpcon = httplib.HTTPSConnection('www.gnu.org')
httpcon.request('GET', '/software/guix/packages/packages.json')
res = httpcon.getresponse()
if res.status != 200:
	print >>sys.stderr, "Cannot grab GUIX JSON file"
	sys.stderr.flush()
	sys.exit(1)

guixdata = res.read()

'''
## in case the data is cached -- TODO
guixjsonfilename = '/tmp/packages-guix.json'
guixfile = open(guixjsonfilename, 'rb')
guixdata = guixfile.read()
guixfile.close()
'''

try:
	guixjson = json.loads(guixdata)
except:
	print >>sys.stderr, "Invalid GUIX JSON data"
	sys.exit(1)

## NixOS exports the available packages in the stable channel
## (for example: 17.03) as JSON
## http://nixos.org/nixpkgs/packages.json.gz
httpcon = httplib.HTTPConnection('nixos.org')
httpcon.request('GET', '/nixpkgs/packages.json.gz')
res = httpcon.getresponse()
if res.status != 200:
	print >>sys.stderr, "Cannot grab Nix JSON file"
	sys.stderr.flush()
	sys.exit(1)

nixbuffer = StringIO.StringIO(res.read())
nixdata = gzip.GzipFile(fileobj=nixbuffer).read()

'''
## in case the data is cached -- TODO
nixjsonfilename = '/tmp/packages.json'
nixfile = open(nixjsonfilename, 'rb')
nixdata = nixfile.read()
nixfile.close()
'''

try:
	nixjson = json.loads(nixdata)
except:
	print >>sys.stderr, "Invalid Nix JSON data"
	sys.exit(1)

guixpackagetoversion = {}
guixurltopackage = {}

for i in guixjson:
	packagename = i['name']
	packageversion = i['version']
	guixpackagetoversion[packagename] = packageversion
	homepage = i['home-page']
	guixurltopackage[homepage] = packagename

nixpackagetoversion = {}
nixurltopackage = {}

for i in nixjson['packages']:
	packagenameversion = nixjson['packages'][i]['name']
	if 'meta' in nixjson['packages'][i]:
		if 'homepage' in nixjson['packages'][i]['meta']:
			homepage = nixjson['packages'][i]['meta']['homepage']
			if homepage != []:
				if not isinstance(homepage, list):
					nixurltopackage[homepage] = packagenameversion
	if not packagenameversion.startswith(i):
		newpkg = i.split('.', 1)
		if len(newpkg) == 2:
			if packagenameversion.startswith(newpkg[1]):
				packageversion = packagenameversion[len(newpkg[1])+1:]
				packagename = packagenameversion[:len(newpkg[1])]
				nixpackagetoversion[packagename] = packageversion
	else:
		packageversion = packagenameversion[len(i)+1:]
		packagename = packagenameversion[:len(i)]
		nixpackagetoversion[packagename] = packageversion

guixpackagenames = guixpackagetoversion.keys()
guixpackagenames.sort()

packagesame = []
for i in guixpackagenames:
	if i in nixpackagetoversion:
		if guixpackagetoversion[i] != nixpackagetoversion[i]:
			packagesame.append(i)

packagelengths = map(lambda x: len(x), packagesame)
packagelengths.sort(reverse=True)
maxpackagelength = packagelengths[0]

guixversionlengths = map(lambda x: len(x), guixpackagetoversion.values())
guixversionlengths.sort(reverse=True)
nixversionlengths = map(lambda x: len(x), nixpackagetoversion.values())
nixversionlengths.sort(reverse=True)
maxversionnix = nixversionlengths[0]
maxversionguix = guixversionlengths[0]

## name + " " + guixversion + " " + nixversion
tablerowlen = maxpackagelength + maxversionnix + maxversionguix + 2

#print '{:<-*tablerowlen}'.format("")
print ('{:->%d}' % tablerowlen).format("")
print ('{:>%d}' % maxpackagelength).format("package name"), ('{:>%d}' % maxversionguix).format("GUIX"), ('{:>%d}' % maxversionnix).format("Nix")
print ('{:->%d}' % tablerowlen).format("")
for i in packagesame:
	print ('{:>%d}' % maxpackagelength).format(i), ('{:>%d}' % maxversionguix).format(guixpackagetoversion[i]), ('{:>%d}' % maxversionnix).format(nixpackagetoversion[i])
