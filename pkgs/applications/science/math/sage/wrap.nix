{ lib
, stdenv
, writeTextFile
, python
}:

{ packageToWrap
, module_name ? packageToWrap.pname
, set ? {}
, prefix ? {}
, code ? ""
, extraInstall ? ""
}:

let
  pythonEscape = str: lib.replaceStrings ["'"] ["a"] (toString str);
  generateExport = var: val: "os.environ['${pythonEscape var}'] = '${pythonEscape val}'";
  generatePrefix = var: val: "os.environ['${pythonEscape var}'] = '${pythonEscape val}:' + os.environ.get('${pythonEscape var}', '')";
  generateWrapperLines = { set, prefix}:
    (lib.mapAttrsToList generateExport set)
      ++ (lib.mapAttrsToList generatePrefix prefix);
  scriptToExecute = "import os\n" + lib.concatStringsSep "\n" (generateWrapperLines { inherit set prefix; }) + "\n" + code;
  targetDir = "${placeholder "out"}/lib/${python.libPrefix}/site-packages/${module_name}/";
  wrapperScript = ''
    import sys
    exec(compile(open('${targetDir}/inject.py').read(), '${targetDir}/inject.py', 'exec'), {}, {})
    sys.path = [ '${packageToWrap}/lib/${python.libPrefix}/site-packages' ] + sys.path
    sys.modules.pop(__name__)
    import ${module_name}
  '';
in
  stdenv.mkDerivation {
    name = "${packageToWrap.name}-wrapper";
    unpackPhase = "
      # do nothing
    ";
    buildPhase = "
      # do nothing
    ";
    installPhase = ''
      mkdir -p "$out/lib/${python.libPrefix}/site-packages/${module_name}/"
      echo ${lib.escapeShellArg scriptToExecute} > "${targetDir}/inject.py"
      echo ${lib.escapeShellArg wrapperScript} > "${targetDir}/__init__.py"
    '' + extraInstall;
    pythonModule = packageToWrap.pythonModule; 
    requiredPythonModules = packageToWrap.requiredPythonModules;
    propagatedBuildInputs = packageToWrap.propagatedBuildInputs;
  }
