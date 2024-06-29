{
  devShellTools,
  emptyFile,
  lib,
  stdenv,
  hello,
}:
let
  inherit (lib) escapeShellArg;
in
{
  # nix-build -A tests.devShellTools.stringValue
  stringValue =
    let inherit (devShellTools) stringValue; in

    stdenv.mkDerivation {
      name = "devShellTools-stringValue-built-tests";

      # Test inputs
      inherit emptyFile hello;
      one = 1;
      boolTrue = true;
      boolFalse = false;
      foo = "foo";
      list = [ 1 2 3 ];
      pathDefaultNix = ./default.nix;
      packages = [ hello emptyFile ];
      # TODO: nested lists

      buildCommand = ''
        touch $out
        ( set -x
          [[ "$one" = ${escapeShellArg (stringValue 1)} ]]
          [[ "$boolTrue" = ${escapeShellArg (stringValue true)} ]]
          [[ "$boolFalse" = ${escapeShellArg (stringValue false)} ]]
          [[ "$foo" = ${escapeShellArg (stringValue "foo")} ]]
          [[ "$hello" = ${escapeShellArg (stringValue hello)} ]]
          [[ "$list" = ${escapeShellArg (stringValue [ 1 2 3 ])} ]]
          [[ "$packages" = ${escapeShellArg (stringValue [ hello emptyFile ])} ]]
          [[ "$pathDefaultNix" = ${escapeShellArg (stringValue ./default.nix)} ]]
          [[ "$emptyFile" = ${escapeShellArg (stringValue emptyFile)} ]]
        ) >log 2>&1 || { cat log; exit 1; }
      '';
    };
}
