{
  capnproto,
  lib,
  fetchFromGitHub,
  protobuf,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "conmon-rs";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "conmon-rs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-o0ojciZPhfHxRtvuc4kvd6ZM6uTizzCLB1Y+VF7ngiE=";
  };

  nativeBuildInputs = [
    capnproto
    protobuf
  ];
  doCheck = false;

  cargoHash = "sha256-Q1jM0yfuQXHKoYKtYxceL/6WHGmNr0MYPfhqlPOzCR4=";

  meta = {
    description = "OCI container runtime monitor written in Rust";
    homepage = "https://github.com/containers/conmon-rs";
    license = lib.licenses.asl20;
    teams = [ lib.teams.podman ];
    platforms = lib.platforms.linux;
  };
})
