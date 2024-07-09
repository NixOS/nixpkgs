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
  # nix-build -A tests.devShellTools.valueToString
  valueToString =
    let inherit (devShellTools) valueToString; in

    stdenv.mkDerivation {
      name = "devShellTools-valueToString-built-tests";

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
          [[ "$one" = ${escapeShellArg (valueToString 1)} ]]
          [[ "$boolTrue" = ${escapeShellArg (valueToString true)} ]]
          [[ "$boolFalse" = ${escapeShellArg (valueToString false)} ]]
          [[ "$foo" = ${escapeShellArg (valueToString "foo")} ]]
          [[ "$hello" = ${escapeShellArg (valueToString hello)} ]]
          [[ "$list" = ${escapeShellArg (valueToString [ 1 2 3 ])} ]]
          [[ "$packages" = ${escapeShellArg (valueToString [ hello emptyFile ])} ]]
          [[ "$pathDefaultNix" = ${escapeShellArg (valueToString ./default.nix)} ]]
          [[ "$emptyFile" = ${escapeShellArg (valueToString emptyFile)} ]]
        ) >log 2>&1 || { cat log; exit 1; }
      '';
    };
}
