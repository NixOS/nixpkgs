{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "aardvark-dns";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "aardvark-dns";
    rev = "v${version}";
    hash = "sha256-mWaB1E/n/N2Tb5bqrMJX2XfPvZBCG+dxar3kGCHgv0I=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-t9qfPz4Jy1RueiDEY2fB3Y1uty0i/Wf0ElsR+nSVF5g=";

  passthru.tests = { inherit (nixosTests) podman; };

  meta = with lib; {
    changelog = "https://github.com/containers/aardvark-dns/releases/tag/${src.rev}";
    description = "Authoritative dns server for A/AAAA container records";
    homepage = "https://github.com/containers/aardvark-dns";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
    mainProgram = "aardvark-dns";
  };
}
