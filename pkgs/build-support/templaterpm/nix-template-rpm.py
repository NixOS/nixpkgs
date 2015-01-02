#!/bin/env python

import sys
import os
import subprocess
import argparse
import shutil
import rpm
import urlparse
import traceback
import toposort





class NixTemplateRPM(object):
  def __init__(self, specFilename, inputDir=None, maintainer="MAINTAINER"):
    rpm.addMacro("buildroot","$out")
    rpm.addMacro("_libdir","lib")
    rpm.addMacro("_libexecdir","libexec")
    rpm.addMacro("_sbindir","sbin")
    rpm.addMacro("_sysconfdir","etc")
    rpm.addMacro("_topdir","SPACER_DIR_FOR_REMOVAL")
    rpm.addMacro("_sourcedir","SOURCE_DIR_SPACER")

    ts = rpm.TransactionSet()

    self.specFilename = specFilename
    self.spec = ts.parseSpec(specFilename)

    self.inputDir = inputDir
    self.maintainer = maintainer

    self.packageGroups = [ "ocaml", "python" ]



  def rewriteCommands(self, string):
    string = string.replace('SPACER_DIR_FOR_REMOVAL/','')
    string = string.replace('SPACER_DIR_FOR_REMOVAL','')
    string = '\n'.join(map(lambda line: ' '.join(map(lambda x: x.replace('SOURCE_DIR_SPACER/','${./')+'}' if x.startswith('SOURCE_DIR_SPACER/') else x, line.split(' '))), string.split('\n')))
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
      if target == None:
        return [ rewrite(x.split('-')) for x in inputs if (not x.split('-')[0] in self.packageGroups) or (len(x.split('-')) == 1) ]
      elif target in self.packageGroups:
        return [ target + '_' + rewrite(x.split('-')[1:]) for x in inputs if (x.split('-')[0] == target) and (len(x.split('-')) > 1)]
      else:
        raise Exception("Unknown target")
        return []

    if target == None:
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
    return self.rewriteInputs(target,self.spec.sourceHeader['requires'])

  def getSelf(self):
    name = self.spec.sourceHeader['name']
    if len(name.split('-')) > 1 and name.split('-')[0] in self.packageGroups:
      return self.rewriteInputs(name.split('-')[0], [self.spec.sourceHeader['name']])[0]
    else:
      return self.rewriteInputs(None, [self.spec.sourceHeader['name']])[0]



  def copyPatches(self, input_dir, output_dir):
    patches = [source for (source, _, flag) in self.spec.sources if flag==2]
    for filename in patches:
      shutil.copyfile(os.path.join(input_dir, filename), os.path.join(output_dir, filename))


  def copySources(self, input_dir, output_dir):
    filenames = [source for (source, _, flag) in self.spec.sources if flag==1 if not urlparse.urlparse(source).scheme in ["http", "https"] ]
    for filename in filenames:
      shutil.copyfile(os.path.join(input_dir, filename), os.path.join(output_dir, filename))



  @property
  def name(self):
    out = 'stdenv.mkDerivation {\n'
    out += '  name = "' + self.rewriteName(self.spec.sourceHeader['name']) + '-' + self.spec.sourceHeader['version'] + '";\n'
    out += '  version = "' + self.spec.sourceHeader['version'] + '";\n'
    return out


  @property
  def src(self):
    sources = [source for (source, _, flag) in self.spec.sources if flag==1 if urlparse.urlparse(source).scheme in ["http", "https"] ]
    out = ''
    for url in sources:
      p = subprocess.Popen(['nix-prefetch-url', url], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
      output, err = p.communicate()
      sha256 = output[:-1] #remove new line
      out += '  src = fetchurl {\n'
      out += '    url = "' + url + '";\n'
      out += '    sha256 = "' + sha256 + '";\n'
      out += '  };\n'
    return out


  @property
  def patch(self):
    patches = [source for (source, _, flag) in self.spec.sources if flag==2]
    out = '  patches = [ ' + ' '.join(map(lambda x: './'+x, patches)) + ' ];\n'
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
    out = '  meta = {\n'
    out += '    homepage = ' + self.spec.sourceHeader['url'] + ';\n'
    out += '    description = "' + self.spec.sourceHeader['summary'] + '";\n'
    out += '    license = stdenv.lib.licenses.' + self.spec.sourceHeader['license'] + ';\n'
    out += '    platforms = [ "i686-linux" "x86_64-linux" ];\n'
    out += '    maintainers = with stdenv.lib.maintainers; [ ' + self.maintainer + ' ];\n'
    out += '  };\n'
    out += '}\n'
    return out



  def __str__(self):
     head = '{stdenv, fetchurl, ' + ', '.join(self.getBuildInputs("ALL")) + '}:\n\n'
     body = [ self.name, self.src, self.patch, self.buildInputs, self.configure, self.build, self.ocamlExtra, self.install, self.meta ]
     return head + '\n'.join(body)


  def __cmp__(self,other):
    if self.getSelf() in other.getBuildInputs("ALL"):
      return 1
    else:
      return -1


  def callPackage(self, output_dir):
    callPackage = '  ' + self.getSelf() + ' = callPackage ' + os.path.relpath(output_dir) + ' {'
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



  def generateTemplate(self, outputDir):
    output_dir = os.path.normpath( os.path.join(outputDir, self.rewriteName(self.spec.sourceHeader['name'])) )
    if not os.path.exists(output_dir):
      os.makedirs(output_dir)

    if self.inputDir != None:
      self.copySources(self.inputDir, output_dir)
      self.copyPatches(self.inputDir, output_dir)

    nixfile = open(os.path.join(output_dir,'default.nix'), 'w')
    nixfile.write(str(self))
    nixfile.close()

    shutil.copyfile(self.specFilename, os.path.join(output_dir, os.path.basename(self.specFilename)))

    self.pkgCall = self.callPackage(output_dir)







if __name__ == "__main__":
    #Parse command line options
    parser = argparse.ArgumentParser(description="Generate .nix templates from RPM spec files")
    parser.add_argument("specs", metavar="SPEC", nargs="+", help="spec file")
    parser.add_argument("-o", "--output", metavar="OUT_DIR", required=True, help="output directory")
    parser.add_argument("-i", "--input", metavar="IN_DIR", default=None, help="input directory")
    parser.add_argument("-m", "--maintainer", metavar="MAINTAINER", required=True, help="package maintainer")
    args = parser.parse_args()


    nameMap = {}

    for specPath in args.specs:
      try:
        sys.stderr.write("INFO: generate nix file from: %s\n" % specPath)
        spec = NixTemplateRPM(specPath, args.input, args.maintainer)
        spec.generateTemplate(args.output)
        nameMap[spec.getSelf()] = spec

      except Exception, e:
        sys.stderr.write("ERROR: %s failed with:\n%s\n%s\n" % (specPath,e.message,traceback.format_exc()))

    graph = {}
    for k, v in nameMap.items():
      graph[k] = set(v.getBuildInputs("ALL"))

    sortedSpecs = toposort.toposort_flatten(graph)
    sortedSpecs = filter( lambda x: x in nameMap.keys(), sortedSpecs)

    print '\n\n'.join(map(lambda x: x.pkgCall, map(lambda x: nameMap[x], sortedSpecs)))
