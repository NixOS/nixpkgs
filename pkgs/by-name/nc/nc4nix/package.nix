{
  lib,
  buildGoModule,
  fetchFromGitHub,
  unstableGitUpdater,
}:

buildGoModule {
  pname = "nc4nix";
  version = "0-unstable-2024-08-01";

  src = fetchFromGitHub {
    owner = "helsinki-systems";
    repo = "nc4nix";
    rev = "827bb7244a3529e71c9474fe1f74aed51a4b08d5";
    hash = "sha256-ToT+VvdXiUMmy0dNJAeyMlzMx87QhZPIwzxPXm2fR7s=";
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
