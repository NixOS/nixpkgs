# Impure functions, for passthru.updateScript runtime only
{
  url,
  version,
  pkgs ? import ../../../../../default.nix { },
}:
let
  inherit (import ./update-utils.nix { inherit (pkgs) lib; })
    getLatestStableVersion
    getSha256
    ;
in
pkgs.mkShell rec {
  buildInputs = [ pkgs.common-updater-scripts ];
  newVersion = getLatestStableVersion;
  newSha256 = getSha256 url version newVersion;
}
