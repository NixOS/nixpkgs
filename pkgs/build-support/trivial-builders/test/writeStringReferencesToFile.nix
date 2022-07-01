{ callPackage, lib, pkgs, runCommand, writeText, writeStringReferencesToFile }:
let
  sample = import ./sample.nix { inherit pkgs; };
  samplePaths = lib.unique (lib.attrValues sample);
  stri = x: "${x}";
  sampleText = writeText "sample-text" (lib.concatStringsSep "\n" (lib.unique (map stri samplePaths)));
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
