{
  capnproto,
  lib,
  fetchFromGitHub,
  protobuf,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "conmon-rs";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "conmon-rs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3+W+keg+4XwbtQDps/9FRVPtX3yuR2sQbkoSusDiLmA=";
  };

  nativeBuildInputs = [
    capnproto
    protobuf
  ];
  doCheck = false;

  cargoHash = "sha256-shfufw5Ompcp8rv5tnuojEP7t7r7eGTvomPVoFv2AFE=";

  meta = {
    description = "OCI container runtime monitor written in Rust";
    homepage = "https://github.com/containers/conmon-rs";
    license = lib.licenses.asl20;
    teams = [ lib.teams.podman ];
    platforms = lib.platforms.linux;
  };
})
