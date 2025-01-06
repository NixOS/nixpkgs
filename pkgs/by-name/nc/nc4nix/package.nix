{
  lib,
  buildGoModule,
  fetchFromGitHub,
  unstableGitUpdater,
}:

buildGoModule {
  pname = "nc4nix";
  version = "0-unstable-2024-09-18";

  src = fetchFromGitHub {
    owner = "helsinki-systems";
    repo = "nc4nix";
    rev = "3474a6a0c686f3deb2ba6022cfd1164632d8af5c";
    hash = "sha256-txpWJ/RHyfxJOhUCeb4Z3mzjdMxPDM1/nLEFO/8/9VQ=";
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
