# SPDX-FileCopyrightText: 2021 Nixpkgs/NixOS contributors
## Custom Nim builder for Nixpkgs.

import std/[json, os, osproc, parseutils, sequtils, streams, strutils, tables]

proc getEnvBool(key: string; default = false): bool =
  ## Parse a boolean environmental variable.
  let val = getEnv(key)
  if val == "": default
  else: parseBool(val)

type
  BuilderAttrs = object
    structuredAttrs: bool
    outputs: Table[string, string]
    nimFlags: seq[string]
    nimDefines: seq[string]
    nimRelease: bool
    nimbleFile: string
    nimDoc: bool
    nimCopySources: bool

proc getSeq(n: JsonNode): seq[string] =
  if not n.isNil: result = n.to(seq[string])

proc getEnvOutputs(): Table[string, string] =
  let outputs = splitWhitespace getEnv("outputs")
  doAssert(outputs.len > 0)
  for output in outputs:
    result[output] = getEnv(output)

proc findNimbleFile(): string =
  ## Copied from Nimble.
  ## Copyright (c) 2015, Dominik Picheta
  ## BSD3
  let dir = getCurrentDir()
  result = ""
  var hits = 0
  for kind, path in walkDir(dir):
    if kind in {pcFile, pcLinkToFile}:
      let ext = path.splitFile.ext
      if ext == ".nimble":
        result = path
        inc hits
  if hits >= 2:
    quit("Only one .nimble file should be present in " & dir)
  elif hits == 0:
    quit("Could not find a file with a .nimble extension in " & dir)

proc getNimbleFilePath(): string =
  ## Get the Nimble file for the current package.
  if existsEnv"nimbleFile":
    getEnv"nimbleFile"
  else:
    findNimbleFile()

proc init[T: BuilderAttrs](_: typedesc[T]): T =
  ## populated based on __structuredAttrs when possible
  let attrFile = getEnv("NIX_ATTRS_JSON_FILE")
  if attrFile != "":
    result.structuredAttrs = true
    let jsonAttrs = parseJson(readFile(attrFile))
    result.outputs = jsonAttrs{"outputs"}.to(Table[string, string])
    result.nimDefines = jsonAttrs{"nimDefines"}.getSeq()
    result.nimFlags = jsonAttrs{"nimFlags"}.getSeq()
    result.nimRelease = jsonAttrs{"nimRelease"}.getBool(true)
    result.nimDoc = jsonAttrs{"nimDoc"}.getBool()
    result.nimCopySources = jsonAttrs{"nimCopySources"}.getBool()
    result.nimbleFile = jsonAttrs{"nimbleFile"}.getStr()
  else:
    result.outputs = getEnvOutputs()
    result.nimFlags = getEnv("nimFlags").split
    result.nimDefines = getEnv("nimDefines").split
    result.nimRelease = getEnvBool("nimRelease", true)
    result.nimDoc = getEnvBool("nimDoc")
    result.nimCopySources = getEnvBool("nimCopySources")


  if result.nimbleFile == "":
    result.nimbleFile = getNimbleFilePath()


let attrs = BuilderAttrs.init()

proc getNimbleValue(filePath, key: string; default = ""): string =
  ## Extract a string value from the Nimble file at ``filePath``.
  var
    fs = newFileStream(filePath, fmRead)
    line: string
  if fs.isNil:
    quit("could not open " & filePath)
  while fs.readline(line):
    if line.startsWith(key):
      var i = key.len
      i.inc skipWhile(line, Whitespace, i)
      if line[i] == '=':
        inc i
        i.inc skipWhile(line, Whitespace, i)
        discard parseUntil(line, result, Newlines, i)
        if result.len > 0 and result[0] == '"':
          result = result.unescape
        return
  default

proc getNimbleValues(filePath, key: string): seq[string] =
  ## Extract a string sequence from the Nimble file at ``filePath``.
  var gunk = getNimbleValue(filePath, key)
  result = gunk.strip(chars = {'@', '[', ']'}).split(',')
  if result == @[""]: reset result
  apply(result) do (s: var string):
    s = s.strip()
    if s.len > 0 and s[0] == '"':
      s = s.unescape()

proc getNimbleValue(attrs: BuilderAttrs, key: string, default = ""): string =
  attrs.nimbleFile.getNimbleValue(key, default)

proc getNimbleValues(attrs: BuilderAttrs, key: string): seq[string] =
  attrs.nimbleFile.getNimbleValues(key)

proc getOutputDir(name: string): string =
  let outDir = attrs.outputs.getOrDefault("out", "/dev/null")
  if name == "out": outDir
  else: attrs.outputs.getOrDefault(name, outDir)

proc configurePhase*() =
  ## Generate "config.nims" which will be read by the Nim
  ## compiler during later phases.
  const configFilePath = "config.nims"
  echo "generating ", configFilePath
  let mode =
    if fileExists configFilePath: fmAppend
    else: fmWrite
  var cfg = newFileStream(configFilePath, mode)
  proc switch(key, val: string) =
    cfg.writeLine("\nswitch(", key.escape, ",", val.escape, ")")
  switch("backend", attrs.getNimbleValue("backend", "c"))
  switch("nimcache", getEnv("NIX_BUILD_TOP", ".") / "nimcache")
  if attrs.nimRelease:
    switch("define", "release")
  for def in attrs.nimDefines:
    if def != "":
      switch("define", def)
  for input in getEnv("NIX_NIM_BUILD_INPUTS").split:
    if input != "":
      for nimbleFile in walkFiles(input / "*.nimble"):
        let inputSrc = normalizedPath(
            input / attrs.getNimbleValue("srcDir", "."))
        echo "found nimble input ", inputSrc
        switch("path", inputSrc)
  close(cfg)

proc buildPhase*() =
  ## Build the programs listed in the Nimble file and
  ## optionally some documentation.
  var cmds: seq[string]
  proc before(idx: int) =
    echo "build job ", idx, ": ", cmds[idx]
  let
    bins = attrs.getNimbleValues("bin")
    srcDir = attrs.getNimbleValue("srcDir", ".")
    binDir = getOutputDir("bin") / "bin"
  if bins != @[]:
    for bin in bins:
      cmds.add("nim compile $# --parallelBuild:$# --outdir:$# $#" %
          [attrs.nimFlags.join(" "), getenv("NIX_BUILD_CORES","1"), binDir, normalizedPath(srcDir / bin)])
  if attrs.nimDoc:
    echo "generating documentation"
    let docDir = getOutputDir("doc") / "doc"
    for path in walkFiles(srcDir / "*.nim"):
      cmds.add("nim doc --outdir:$# $#" % [docDir, path])
  if cmds.len > 0:
    let err = execProcesses(
      cmds, n = 1,
      beforeRunEvent = before)
    if err != 0: quit("build phase failed", err)

proc installPhase*() =
  ## Install the Nim sources if ``nimCopySources`` is
  ## set in the environment.
  if attrs.nimCopySources:
    let
      srcDir = attrs.getNimbleValue("srcDir", ".")
      devDir = getOutputDir("dev")
    echo "Install ", srcDir, " to ", devDir
    copyDir(normalizedPath(srcDir), normalizedPath(devDir / srcDir))
    copyFile(attrs.nimbleFile, devDir / attrs.nimbleFile.extractFilename)

proc checkPhase*() =
  ## Build and run the tests in ``tests``.
  var cmds: seq[string]
  proc before(idx: int) =
    echo "check job ", idx, ": ", cmds[idx]
  for path in walkPattern("tests/t*.nim"):
    cmds.add("nim r $# $#" % [attrs.nimFlags.join(" "), path])
  let err = execProcesses(
    cmds, n = 1,
    beforeRunEvent = before)
  if err != 0: quit("check phase failed", err)

when isMainModule:
  import std/parseopt
  var phase: string

  for kind, key, val in getopt():
    case kind
    of cmdLongOption:
      case key.toLowerAscii
      of "phase":
        if phase != "": quit("only a single phase may be specified")
        phase = val
      else: quit("unhandled argument " & key)
    of cmdEnd: discard
    else: quit("unhandled argument " & key)

  case phase
  of "configure": configurePhase()
  of "build": buildPhase()
  of "install": installPhase()
  of "check": checkPhase()
  else: quit("unhandled phase " & phase)
