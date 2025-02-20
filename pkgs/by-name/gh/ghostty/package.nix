{
  lib,
  writeShellApplication,
  ghostty-unwrapped,
  settings ? { },
}:

let
  mkFlag =
    with lib;
    k: v:
    if isString v then
      "--${k}=\"${v}\""
    else if isList v && all isString v then
      concatMapStringsSep " " (v: "--${k}=\"${v}\"") v
    else
      throw "Ghostty settings value must be string or list of strings: ${v}";
in
if settings == { } then
  ghostty-unwrapped
else
  writeShellApplication {
    name = "ghostty";

    derivationArgs = {
      inherit (ghostty-unwrapped) pname version meta;
    };

    text = ''
      options=( ${lib.concatStringsSep " " (lib.mapAttrsToList mkFlag settings)} )
      if [[ $# -gt 0 && "$1" == "+"* ]]; then
        ${lib.getExe ghostty-unwrapped} "$@"
      else
        ${lib.getExe ghostty-unwrapped} "''${options[@]}" "$@"
      fi
    '';
  }
