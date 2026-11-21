{
  capnproto,
  lib,
  fetchFromGitHub,
  protobuf,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "conmon-rs";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "conmon-rs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HFdM30BR3uGsxGaAdnRGjrZZEObVwwXG3FSlL8FvJvA=";
  };

  nativeBuildInputs = [
    capnproto
    protobuf
  ];
  doCheck = false;

  cargoHash = "sha256-pT9s4u+hTN3NarXQwQxk9niWljwgIbm50jbLyv2ADHE=";

  meta = {
    description = "OCI container runtime monitor written in Rust";
    homepage = "https://github.com/containers/conmon-rs";
    license = lib.licenses.asl20;
    teams = [ lib.teams.podman ];
    platforms = lib.platforms.linux;
  };
})
