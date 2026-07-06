{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aardvark-dns";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "aardvark-dns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w+qHHq/4jdkEzyoxfy1h6Vb+55uWLJhirbBSZHxLxTU=";
  };

  cargoHash = "sha256-rpflZfMYNlrn13Cv3znkS2Jp9peyIJDQrXVnVnVuy9g=";

  passthru.tests = { inherit (nixosTests) podman; };

  meta = {
    changelog = "https://github.com/containers/aardvark-dns/releases/tag/${finalAttrs.src.rev}";
    description = "Authoritative dns server for A/AAAA container records";
    homepage = "https://github.com/containers/aardvark-dns";
    license = lib.licenses.asl20;
    teams = with lib.teams; [ podman ];
    platforms = lib.platforms.linux;
    mainProgram = "aardvark-dns";
  };
})
