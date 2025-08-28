{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "aardvark-dns";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "aardvark-dns";
    tag = "v${version}";
    hash = "sha256-mC+PP5sXt2O0CgxxyzS2WjtQe0RjuKNCamrjRY7qBP8=";
  };

  cargoHash = "sha256-e/VxQgpTOS4snM78BewvloWap9cU+Vzlahlr00BWmVY=";

  passthru.tests = { inherit (nixosTests) podman; };

  meta = {
    changelog = "https://github.com/containers/aardvark-dns/releases/tag/${src.rev}";
    description = "Authoritative dns server for A/AAAA container records";
    homepage = "https://github.com/containers/aardvark-dns";
    license = lib.licenses.asl20;
    teams = with lib.teams; [ podman ];
    platforms = lib.platforms.linux;
    mainProgram = "aardvark-dns";
  };
}
