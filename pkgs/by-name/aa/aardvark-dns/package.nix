{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "aardvark-dns";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "aardvark-dns";
    tag = "v${version}";
    hash = "sha256-drDu+YaqlylDRJHs6ctbDvhaec3UqQ+0GsUeHfhY4Zg=";
  };

  cargoHash = "sha256-YUgaXx/+rZrTtscQIg3bkIp4L1bnjmSiudrim+ZXa64=";

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
