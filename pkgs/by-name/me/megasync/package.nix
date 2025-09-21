{
  lib,
  stdenv,
  callPackage,
  ...
}@args:

let
  extraArgs = removeAttrs args [ "callPackage" ];

  pname = "megasync";

  meta = {
    description = "Easy automated syncing between your computers and your MEGA Cloud Drive";
    homepage = "https://mega.nz/";
    license = lib.licenses.unfreeRedistributable;
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "megasync";
  };

in
if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix (extraArgs // { inherit pname meta; })
else
  callPackage ./linux.nix (extraArgs // { inherit pname meta; })
