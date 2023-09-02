{ lib
, stdenv
, callPackage
, fetchFromGitHub
, runCommandLocal
, symlinkJoin
}:

let
  mkElectron = callPackage ./generic.nix { };
in
{
  electron_24-bin = mkElectron "24.1.2" {
    x86_64-linux = "93655b60cd72671f5f595d0b6f7af0c265065fd1d994f9aefe78c0ed6854c28c";
    x86_64-darwin = "6b773611bb0029e3061a54688f45faddc8a05a316da59d893d4a3cdc90e528eb";
    aarch64-darwin = "048819663035f3c82f07d2aca8873f2779c1dcbeee6d8e91b0239a7088ca9cf6";
    headers = "";
  };
}
