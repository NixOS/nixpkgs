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
    rev = "v${version}";
    hash = "sha256-drDu+YaqlylDRJHs6ctbDvhaec3UqQ+0GsUeHfhY4Zg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-YUgaXx/+rZrTtscQIg3bkIp4L1bnjmSiudrim+ZXa64=";

  passthru.tests = { inherit (nixosTests) podman; };

  meta = with lib; {
    changelog = "https://github.com/containers/aardvark-dns/releases/tag/${src.rev}";
    description = "Authoritative dns server for A/AAAA container records";
    homepage = "https://github.com/containers/aardvark-dns";
    license = licenses.asl20;
    teams = [ teams.podman ];
    platforms = platforms.linux;
    mainProgram = "aardvark-dns";
  };
}
