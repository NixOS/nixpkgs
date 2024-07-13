{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "nc4nix";
  version = "0-unstable-2024-05-24";

  src = fetchFromGitHub {
    owner = "helsinki-systems";
    repo = "nc4nix";
    rev = "9d605367d0d952de9d022155e8df28e6793ff104";
    hash = "sha256-QAtN4fcbsX0e6DIchOjxpHDDmIt7SGiN8riLplqXIYs=";
  };

  vendorHash = "sha256-qntRsv3KvAbV3lENjAHKkQOqh3uTo3gacfwase489tQ=";

  meta = {
    description = "Packaging helper for Nextcloud apps";
    mainProgram = "nc4nix";
    homepage = "https://github.com/helsinki-systems/nc4nix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
    platforms = lib.platforms.linux;
  };
}
