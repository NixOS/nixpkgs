{ utils
, writeText
, defaultGcc
, python3Full
}:
let


  pythoncfg = {
    compilers = "&python";
    group.python.compilers = "pythondefault";
    compiler.pythondefault.exe = "${python3Full}/bin/python";
    compiler.pythondefault.name = "python ${python3Full.version}";
    defaultCompiler = "pythondefault";
    instructionSet = "python";
    supportsBinary = "false";
    interpreted = "true";
    compilerType = "python";
    objdumper = "";
    demangler = "";
    postProcess = "";
    options = "";
    needsMulti = "false";
    supportsExecute = "true";
    stubText = "def main():";
    disasmScript = "";
  };

in
writeText "python.defaults.properties" ''
  ${utils.attrToDot pythoncfg }

''
