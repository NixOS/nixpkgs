{
  lib,
  buildGoModule,
  fetchFromGitHub,
  unstableGitUpdater,
}:

buildGoModule {
  pname = "nc4nix";
  version = "0-unstable-2024-09-28";

  src = fetchFromGitHub {
    owner = "helsinki-systems";
    repo = "nc4nix";
    rev = "9bdda09dacf31d7b33a1b53f17b9a8ad212f0271";
    hash = "sha256-imu8R9nbpUuXZvqKvJsy1phAgvBz4tHac5fwkb5igYo=";
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
