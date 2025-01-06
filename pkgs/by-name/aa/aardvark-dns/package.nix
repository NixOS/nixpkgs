{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "aardvark-dns";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-VXuTHc/t+5QidTqMptoQqircHTtYzeEXfFFII8jeOrI=";
  };

  cargoHash = "sha256-MHNIb1hNoL/62aUDNs0wd4086m3Zm4bnRp+VKXE4gJs=";

  passthru.tests = { inherit (nixosTests) podman; };

  meta = {
    changelog = "https://github.com/containers/aardvark-dns/releases/tag/${src.rev}";
    description = "Authoritative dns server for A/AAAA container records";
    homepage = "https://github.com/containers/aardvark-dns";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ] ++ lib.teams.podman.members;
    platforms = lib.platforms.linux;
    mainProgram = "aardvark-dns";
  };
}
