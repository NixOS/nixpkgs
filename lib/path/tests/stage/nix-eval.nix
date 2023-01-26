{
  libPath,
  caseDir,
  variable,
  exprFile,
}:
let
  lib = import libPath;

  result = lib.concatMapStringsSep "\n" (case:
    let
      localCaseDir = caseDir + "/${case}";
      scope = lib.mapAttrs (name: type:
        builtins.readFile (localCaseDir + "/${name}")
      ) (builtins.readDir localCaseDir) // {
        inherit lib;
      };
      result = builtins.scopedImport scope exprFile;
    in ''
      printf "%s" ${lib.escapeShellArg result} > ${lib.escapeShellArg (localCaseDir + "/${variable}")}
    ''
  ) (lib.attrNames (builtins.readDir caseDir));

in result
