{ stdenv, callPackage, ... }@args:
let
  extraArgs = removeAttrs args [ "callPackage" ];
in
if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix (extraArgs // { })
else
  callPackage ./linux.nix (extraArgs // { })
