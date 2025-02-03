{
  lib,
  buildGoModule,
  fetchFromGitHub,
  unstableGitUpdater,
}:

buildGoModule {
  pname = "nc4nix";
  version = "0-unstable-2024-09-07";

  src = fetchFromGitHub {
    owner = "helsinki-systems";
    repo = "nc4nix";
    rev = "6be14e56aabc0c0a686037a7d1fa6fff8ea97045";
    hash = "sha256-RVimsyyErf9eaHLIRp5U8zHJSNC2vBlk/ga4VRitJM8=";
  };

  vendorHash = "sha256-qntRsv3KvAbV3lENjAHKkQOqh3uTo3gacfwase489tQ=";

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Packaging helper for Nextcloud apps";
    mainProgram = "nc4nix";
    homepage = "https://github.com/helsinki-systems/nc4nix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
    platforms = lib.platforms.linux;
  };
}
