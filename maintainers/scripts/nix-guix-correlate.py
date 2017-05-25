#!/usr/bin/python

import os, sys, json

guixjsonfilename = '/tmp/packages-guix.json'
nixjsonfilename = '/tmp/packages.json'

guixfile = open(guixjsonfilename, 'rb')
nixfile = open(nixjsonfilename, 'rb')

guixdata = guixfile.read()
guixfile.close()

nixdata = nixfile.read()
nixfile.close()

guixjson = json.loads(guixdata)
nixjson = json.loads(nixdata)

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
