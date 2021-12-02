{ callPackage, lib, pkgs, runCommand, writeText, writeStringReferencesToFile }:
let
  sample = import ./sample.nix { inherit pkgs; };
  samplePaths = lib.unique (lib.attrValues sample);
  str2drv = x: "${x}";
  sampleText = concatText "cample-concat" (lib.unique (map str2drv samplePaths));
  stringReferencesText =
    writeStringReferencesToFile
      ((lib.concatMapStringsSep "fillertext"
        stri
        (lib.attrValues sample)) + ''
        STORE=${builtins.storeDir};\nsystemctl start bar-foo.service
      '');
in
runCommand "test-writeStringReferencesToFile" { } ''
  diff -U3 <(sort ${stringReferencesText}) <(sort ${sampleText})
  touch $out
''
