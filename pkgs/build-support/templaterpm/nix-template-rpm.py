#!/bin/env python

import sys
import os
import subprocess
import argparse
import re
import shutil
import rpm
import urlparse
import traceback
import toposort





class SPECTemplate(object):
  def __init__(self, specFilename, outputDir, inputDir=None, buildRootInclude=None, translateTable=None, repositoryDir=None, allPackagesDir=None, maintainer="MAINTAINER"):
    rpm.addMacro("buildroot","$out")
    rpm.addMacro("_libdir","lib")
    rpm.addMacro("_libexecdir","libexec")
    rpm.addMacro("_sbindir","sbin")
    rpm.addMacro("_sysconfdir","etc")
    rpm.addMacro("_topdir","SPACER_DIR_FOR_REMOVAL")
    rpm.addMacro("_sourcedir","SOURCE_DIR_SPACER")

    self.packageGroups = [ "ocaml", "python" ]

    ts = rpm.TransactionSet()

    self.specFilename = specFilename
    self.spec = ts.parseSpec(specFilename)

    self.inputDir = inputDir
    self.buildRootInclude = buildRootInclude
    self.repositoryDir = repositoryDir
    self.allPackagesDir = allPackagesDir
    self.maintainer = maintainer

    self.translateTable = translateTable

    self.facts = self.getFacts()
    self.key = self.getSelfKey()

    tmpDir = os.path.join(outputDir, self.rewriteName(self.spec.sourceHeader['name']))
    if self.translateTable is not None:
      self.relOutputDir = self.translateTable.path(self.key,tmpDir)
    else:
      self.relOutputDir = tmpDir

    self.final_output_dir = os.path.normpath( self.relOutputDir )

    if self.repositoryDir is not None:
      self.potential_repository_dir = os.path.normpath( os.path.join(self.repositoryDir,self.relOutputDir) )



  def rewriteCommands(self, string):
    string = string.replace('SPACER_DIR_FOR_REMOVAL/','')
    string = string.replace('SPACER_DIR_FOR_REMOVAL','')
    string = '\n'.join(map(lambda line: ' '.join(map(lambda x: x.replace('SOURCE_DIR_SPACER/',('${./' if (self.buildRootInclude is None) else '${buildRoot}/usr/share/buildroot/SOURCES/'))+('}' if (self.buildRootInclude is None) else '') if x.startswith('SOURCE_DIR_SPACER/') else x, line.split(' '))), string.split('\n')))
    string = string.replace('\n','\n    ')
    string = string.rstrip()
    return string


  def rewriteName(self, string):
    parts = string.split('-')
    parts = filter(lambda x: not x == "devel", parts)
    parts = filter(lambda x: not x == "doc", parts)
    if len(parts) > 1 and parts[0] in self.packageGroups:
      return parts[0] + '-' + ''.join(parts[1:2] + map(lambda x: x.capitalize(), parts[2:]))
    else:
      return ''.join(parts[:1] + map(lambda x: x.capitalize(), parts[1:]))


  def rewriteInputs(self,target,inputs):
    camelcase = lambda l: l[:1] + map(lambda x: x.capitalize(), l[1:])
    filterDevel = lambda l: filter(lambda x: not x == "devel", l)
    filterDoc = lambda l: filter(lambda x: not x == "doc", l)
    rewrite = lambda l: ''.join(camelcase(filterDoc(filterDevel(l))))

    def filterPackageGroup(target):
      if target is None:
        return [ rewrite(x.split('-')) for x in inputs if (not x.split('-')[0] in self.packageGroups) or (len(x.split('-')) == 1) ]
      elif target in self.packageGroups:
        return [ target + '_' + rewrite(x.split('-')[1:]) for x in inputs if (x.split('-')[0] == target) and (len(x.split('-')) > 1)]
      else:
        raise Exception("Unknown target")
        return []

    if target is None:
      packages = filterPackageGroup(None)
      packages.sort()
    elif target in self.packageGroups:
      packages = filterPackageGroup(target)
      packages.sort()
    elif target == "ALL":
      packages = []
      for t in [None] + self.packageGroups:
        tmp = filterPackageGroup(t)
        tmp.sort()
        packages += tmp
    else:
      raise Exception("Unknown target")
      packages = []

    return packages


  def getBuildInputs(self,target=None):
    inputs = self.rewriteInputs(target,self.spec.sourceHeader['requires'])
    if self.translateTable is not None:
      return map(lambda x: self.translateTable.name(x), inputs)
    else:
      return inputs

  def getSelfKey(self):
    name = self.spec.sourceHeader['name']
    if len(name.split('-')) > 1 and name.split('-')[0] in self.packageGroups:
      key = self.rewriteInputs(name.split('-')[0], [self.spec.sourceHeader['name']])[0]
    else:
      key = self.rewriteInputs(None, [self.spec.sourceHeader['name']])[0]
    return key

  def getSelf(self):
    if self.translateTable is not None:
      return self.translateTable.name(self.key)
    else:
      return self.key




  def copyPatches(self, input_dir, output_dir):
    patches = [source for (source, _, flag) in self.spec.sources if flag==2]
    for filename in patches:
      shutil.copyfile(os.path.join(input_dir, filename), os.path.join(output_dir, filename))


  def copySources(self, input_dir, output_dir):
    filenames = [source for (source, _, flag) in self.spec.sources if flag==1 if not urlparse.urlparse(source).scheme in ["http", "https"] ]
    for filename in filenames:
      shutil.copyfile(os.path.join(input_dir, filename), os.path.join(output_dir, filename))


  def getFacts(self):
    facts = {}
    facts["name"] = self.rewriteName(self.spec.sourceHeader['name'])
    facts["version"] = self.spec.sourceHeader['version']

    facts["url"] = []
    facts["sha256"] = []
    sources = [source for (source, _, flag) in self.spec.sources if flag==1 if urlparse.urlparse(source).scheme in ["http", "https"] ]
    for url in sources:
      p = subprocess.Popen(['nix-prefetch-url', url], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
      output, err = p.communicate()
      sha256 = output[:-1] #remove new line
      facts["url"].append(url)
      facts["sha256"].append(sha256)

    patches = [source for (source, _, flag) in self.spec.sources if flag==2]
    if self.buildRootInclude is None:
      facts["patches"] = map(lambda x: './'+x, patches)
    else:
      facts["patches"] = map(lambda x: '"${buildRoot}/usr/share/buildroot/SOURCES/'+x+'"', reversed(patches))

    return facts


  @property
  def name(self):
    out = '  name = "' + self.facts["name"] + '-' + self.facts["version"] + '";\n'
    out += '  version = "' + self.facts['version'] + '";\n'
    return out


  @property
  def src(self):
    sources = [source for (source, _, flag) in self.spec.sources if flag==1 if urlparse.urlparse(source).scheme in ["http", "https"] ]
    out = ''
    for (url,sha256) in zip(self.facts['url'],self.facts['sha256']):
      out += '  src = fetchurl {\n'
      out += '    url = "' + url + '";\n'
      out += '    sha256 = "' + sha256 + '";\n'
      out += '  };\n'
    return out


  @property
  def patch(self):
    out = '  patches = [ ' + ' '.join(self.facts['patches']) + ' ];\n'
    return out


  @property
  def buildInputs(self):
    out = '  buildInputs = [ '
    out += ' '.join(self.getBuildInputs("ALL"))
    out += ' ];\n'
    return out


  @property
  def configure(self):
    out = '  configurePhase = \'\'\n    ' + self.rewriteCommands(self.spec.prep) + '\n    \'\';\n';
    return out


  @property
  def build(self):
    out = '  buildPhase = \'\'\n    ' + self.rewriteCommands(self.spec.build) + '\n    \'\';\n';
    return out


  @property
  def install(self):
    out = '  installPhase = \'\'\n    ' + self.rewriteCommands(self.spec.install) + '\n    \'\';\n';
    return out

  @property
  def ocamlExtra(self):
    if "ocaml" in self.getBuildInputs("ALL"):
      return '  createFindlibDestdir = true;\n'
    else:
      return ''


  @property
  def meta(self):
    out = '  meta = with lib; {\n'
    out += '    homepage = ' + self.spec.sourceHeader['url'] + ';\n'
    out += '    description = "' + self.spec.sourceHeader['summary'] + '";\n'
    out += '    license = lib.licenses.' + self.spec.sourceHeader['license'] + ';\n'
    out += '    platforms = [ "i686-linux" "x86_64-linux" ];\n'
    out += '    maintainers = with lib.maintainers; [ ' + self.maintainer + ' ];\n'
    out += '  };\n'
    out += '}\n'
    return out


  def __str__(self):
    head = '{lib, stdenv, fetchurl, ' + ', '.join(self.getBuildInputs("ALL")) + '}:\n\n'
    head += 'stdenv.mkDerivation {\n'
    body = [ self.name, self.src, self.patch, self.buildInputs, self.configure, self.build, self.ocamlExtra, self.install, self.meta ]
    return head + '\n'.join(body)


  def getTemplate(self):
    head = '{lib, stdenv, buildRoot, fetchurl, ' + ', '.join(self.getBuildInputs("ALL")) + '}:\n\n'
    head += 'let\n'
    head += '  buildRootInput = (import "${buildRoot}/usr/share/buildroot/buildRootInput.nix") { fetchurl=fetchurl; buildRoot=buildRoot; };\n'
    head += 'in\n\n'
    head += 'stdenv.mkDerivation {\n'
    head += '  inherit (buildRootInput.'+self.rewriteName(self.spec.sourceHeader['name'])+') name version src;\n'
    head += '  patches = buildRootInput.'+self.rewriteName(self.spec.sourceHeader['name'])+'.patches ++ [];\n\n'
    body = [ self.buildInputs, self.configure, self.build, self.ocamlExtra, self.install, self.meta ]
    return head + '\n'.join(body)


  def getInclude(self):
    head = self.rewriteName(self.spec.sourceHeader['name']) + ' = {\n'
    body = [ self.name, self.src, self.patch ]
    return head + '\n'.join(body) + '};\n'


  def __cmp__(self,other):
    if self.getSelf() in other.getBuildInputs("ALL"):
      return 1
    else:
      return -1


  def callPackage(self):
    callPackage = '  ' + self.getSelf() + ' = callPackage ' + os.path.relpath(self.final_output_dir, self.allPackagesDir) + ' {'
    newline = False;
    for target in self.packageGroups:
      tmp = self.getBuildInputs(target)
      if len(tmp) > 0:
        newline = True;
        callPackage += '\n    ' + 'inherit (' + target + 'Packages) ' + ' '.join(tmp) + ';'
    if newline:
      callPackage += '\n  };'
    else:
      callPackage += ' };'
    return callPackage



  def generateCombined(self):
    if not os.path.exists(self.final_output_dir):
      os.makedirs(self.final_output_dir)

    if self.inputDir is not None:
      self.copySources(self.inputDir, self.final_output_dir)
      self.copyPatches(self.inputDir, self.final_output_dir)

    nixfile = open(os.path.join(self.final_output_dir,'default.nix'), 'w')
    nixfile.write(str(self))
    nixfile.close()

    shutil.copyfile(self.specFilename, os.path.join(self.final_output_dir, os.path.basename(self.specFilename)))



  def generateSplit(self):
    if not os.path.exists(self.final_output_dir):
      os.makedirs(self.final_output_dir)

    nixfile = open(os.path.join(self.final_output_dir,'default.nix'), 'w')
    nixfile.write(self.getTemplate())
    nixfile.close()

    return self.getInclude()






class NixTemplate(object):
  def __init__(self, nixfile):
    self.nixfile = nixfile
    self.original = { "name":None, "version":None, "url":None, "sha256":None, "patches":None }
    self.update = { "name":None, "version":None, "url":None, "sha256":None, "patches":None }
    self.matchedLines = {}

    if os.path.isfile(nixfile):
      with file(nixfile, 'r') as infile:
        for (n,line) in enumerate(infile):
          name = re.match(r'^\s*name\s*=\s*"(.*?)"\s*;\s*$', line)
          version = re.match(r'^\s*version\s*=\s*"(.*?)"\s*;\s*$', line)
          url = re.match(r'^\s*url\s*=\s*"?(.*?)"?\s*;\s*$', line)
          sha256 = re.match(r'^\s*sha256\s*=\s*"(.*?)"\s*;\s*$', line)
          patches = re.match(r'^\s*patches\s*=\s*(\[.*?\])\s*;\s*$', line)
          if name is not None and self.original["name"] is None:
              self.original["name"] = name.group(1)
              self.matchedLines[n] = "name"
          if version is not None and self.original["version"] is None:
              self.original["version"] = version.group(1)
              self.matchedLines[n] = "version"
          if url is not None and self.original["url"] is None:
              self.original["url"] = url.group(1)
              self.matchedLines[n] = "url"
          if sha256 is not None and self.original["sha256"] is None:
              self.original["sha256"] = sha256.group(1)
              self.matchedLines[n] = "sha256"
          if patches is not None and self.original["patches"] is None:
              self.original["patches"] = patches.group(1)
              self.matchedLines[n] = "patches"


  def generateUpdated(self, nixOut):
    nixTemplateFile = open(os.path.normpath(self.nixfile),'r')
    nixOutFile = open(os.path.normpath(nixOut),'w')
    for (n,line) in enumerate(nixTemplateFile):
      if self.matchedLines.has_key(n) and self.update[self.matchedLines[n]] is not None:
        nixOutFile.write(line.replace(self.original[self.matchedLines[n]], self.update[self.matchedLines[n]], 1))
      else:
        nixOutFile.write(line)
    nixTemplateFile.close()
    nixOutFile.close()


  def loadUpdate(self,orig):
    if orig.has_key("name") and orig.has_key("version"):
      self.update["name"] = orig["name"] + '-' + orig["version"]
      self.update["version"] = orig["version"]
    if orig.has_key("url") and orig.has_key("sha256") and len(orig["url"])>0:
      self.update["url"] = orig["url"][0]
      self.update["sha256"] = orig["sha256"][0]
      for url in orig["url"][1:-1]:
        sys.stderr.write("WARNING: URL has been dropped: %s\n" % url)
    if orig.has_key("patches"):
      self.update["patches"] = '[ ' + ' '.join(orig['patches']) + ' ]'


class TranslationTable(object):
  def __init__(self):
    self.tablePath = {}
    self.tableName = {}

  def update(self, key, path, name=None):
    self.tablePath[key] = path
    if name is not None:
      self.tableName[key] = name

  def readTable(self, tableFile):
    with file(tableFile, 'r') as infile:
      for line in infile:
        match = re.match(r'^(.+?)\s+(.+?)\s+(.+?)\s*$', line)
        if match is not None:
          if not self.tablePath.has_key(match.group(1)):
            self.tablePath[match.group(1)] = match.group(2)
          if not self.tableName.has_key(match.group(1)):
            self.tableName[match.group(1)] = match.group(3)
        else:
          match = re.match(r'^(.+?)\s+(.+?)\s*$', line)
          if not self.tablePath.has_key(match.group(1)):
            self.tablePath[match.group(1)] = match.group(2)

  def writeTable(self, tableFile):
    outFile = open(os.path.normpath(tableFile),'w')
    keys = self.tablePath.keys()
    keys.sort()
    for k in keys:
      if self.tableName.has_key(k):
        outFile.write( k + " " + self.tablePath[k] + " " + self.tableName[k] + "\n" )
      else:
        outFile.write( k + " " + self.tablePath[k] + "\n" )
    outFile.close()

  def name(self, key):
   if self.tableName.has_key(key):
     return self.tableName[key]
   else:
     return key

  def path(self, key, orig):
   if self.tablePath.has_key(key):
     return self.tablePath[key]
   else:
     return orig





if __name__ == "__main__":
    #Parse command line options
    parser = argparse.ArgumentParser(description="Generate .nix templates from RPM spec files")
    parser.add_argument("specs", metavar="SPEC", nargs="+", help="spec file")
    parser.add_argument("-o", "--output", metavar="OUT_DIR", required=True, help="output directory")
    parser.add_argument("-b", "--buildRoot", metavar="BUILDROOT_DIR", default=None, help="buildroot output directory")
    parser.add_argument("-i", "--inputSources", metavar="IN_DIR", default=None, help="sources input directory")
    parser.add_argument("-m", "--maintainer", metavar="MAINTAINER", default="__NIX_MAINTAINER__", help="package maintainer")
    parser.add_argument("-r", "--repository", metavar="REP_DIR", default=None, help="nix repository to compare output against")
    parser.add_argument("-t", "--translate", metavar="TRANSLATE_TABLE", default=None, help="path of translation table for name and path")
    parser.add_argument("-u", "--translateOut", metavar="TRANSLATE_OUT", default=None, help="output path for updated translation table")
    parser.add_argument("-a", "--allPackages", metavar="ALL_PACKAGES", default=None, help="top level dir to call packages from")
    args = parser.parse_args()

    allPackagesDir = os.path.normpath( os.path.dirname(args.allPackages) )
    if not os.path.exists(allPackagesDir):
      os.makedirs(allPackagesDir)

    buildRootContent = {}
    nameMap = {}

    newTable = TranslationTable()
    if args.translate is not None:
      table = TranslationTable()
      table.readTable(args.translate)
      newTable.readTable(args.translate)
    else:
      table = None

    for specPath in args.specs:
      try:
        sys.stderr.write("INFO: generate nix file from: %s\n" % specPath)

        spec = SPECTemplate(specPath, args.output, args.inputSources, args.buildRoot, table, args.repository, allPackagesDir, args.maintainer)
        if args.repository is not None:
          if os.path.exists(os.path.join(spec.potential_repository_dir,'default.nix')):
            nixTemplate = NixTemplate(os.path.join(spec.potential_repository_dir,'default.nix'))
            nixTemplate.loadUpdate(spec.facts)
            if not os.path.exists(spec.final_output_dir):
              os.makedirs(spec.final_output_dir)
            nixTemplate.generateUpdated(os.path.join(spec.final_output_dir,'default.nix'))
          else:
            sys.stderr.write("WARNING: Repository does not contain template: %s\n" % os.path.join(spec.potential_repository_dir,'default.nix'))
            if args.buildRoot is None:
              spec.generateCombined()
            else:
              buildRootContent[spec.key] = spec.generateSplit()
        else:
          if args.buildRoot is None:
            spec.generateCombined()
          else:
            buildRootContent[spec.key] = spec.generateSplit()

        newTable.update(spec.key,spec.relOutputDir,spec.getSelf())
        nameMap[spec.getSelf()] = spec

      except Exception, e:
        sys.stderr.write("ERROR: %s failed with:\n%s\n%s\n" % (specPath,e.message,traceback.format_exc()))

    if args.translateOut is not None:
      if not os.path.exists(os.path.dirname(os.path.normpath(args.translateOut))):
        os.makedirs(os.path.dirname(os.path.normpath(args.translateOut)))
      newTable.writeTable(args.translateOut)

    graph = {}
    for k, v in nameMap.items():
      graph[k] = set(v.getBuildInputs("ALL"))

    sortedSpecs = toposort.toposort_flatten(graph)
    sortedSpecs = filter( lambda x: x in nameMap.keys(), sortedSpecs)

    allPackagesFile = open(os.path.normpath( args.allPackages ), 'w')
    allPackagesFile.write( '\n\n'.join(map(lambda x: x.callPackage(), map(lambda x: nameMap[x], sortedSpecs))) )
    allPackagesFile.close()

    if args.buildRoot is not None:
      buildRootFilename = os.path.normpath( args.buildRoot )
      if not os.path.exists(os.path.dirname(buildRootFilename)):
        os.makedirs(os.path.dirname(buildRootFilename))
      buildRootFile = open(buildRootFilename, 'w')
      buildRootFile.write( "{ fetchurl, buildRoot }: {\n\n" )
      keys = buildRootContent.keys()
      keys.sort()
      for k in keys:
        buildRootFile.write( buildRootContent[k] + '\n' )
      buildRootFile.write( "}\n" )
      buildRootFile.close()


