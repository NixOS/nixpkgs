# Impure functions, for passthru.updateScript runtime only
{ aarch64Url
, x86_64Url
, version
, pkgs ? import ../../../../../default.nix { }
,
}:
let
  inherit (import ./update-utils.nix { inherit (pkgs) lib; })
    getLatestStableVersion
    getSha256;
in
pkgs.mkShell rec {
  buildInputs = [ pkgs.common-updater-scripts ];
  newVersion = getLatestStableVersion;
  newAarch64Sha256 = getSha256 aarch64Url version newVersion;
  newX86_64Sha256 = getSha256 x86_64Url version newVersion;
}
