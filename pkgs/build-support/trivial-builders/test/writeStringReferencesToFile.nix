{
  callPackage,
  lib,
  pkgs,
  runCommand,
  samples,
  writeText,
  writeStringReferencesToFile,
}:
let
  samplePaths = lib.unique (lib.attrValues samples);
  stri = x: "${x}";
  sampleText = writeText "sample-text" (
    lib.concatStringsSep "\n" (lib.unique (map stri samplePaths))
  );
  stringReferencesText = writeStringReferencesToFile (
    (lib.concatMapStringsSep "fillertext" stri (lib.attrValues samples))
    + ''
      STORE=${builtins.storeDir};\nsystemctl start bar-foo.service
    ''
  );
in
runCommand "test-writeStringReferencesToFile" { } ''
  diff -U3 <(sort ${stringReferencesText}) <(sort ${sampleText})
  touch $out
''
