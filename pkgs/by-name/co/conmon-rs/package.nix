{
  capnproto,
  lib,
  fetchFromGitHub,
  protobuf,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "conmon-rs";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "conmon-rs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aeicug8d5RKFgq7ZSGBN7qY0PvlZcTeMwYMYXTS3Gvw=";
  };

  nativeBuildInputs = [
    capnproto
    protobuf
  ];
  doCheck = false;

  cargoHash = "sha256-8GtwbX+FOE+upKJbQFGv+RJDZHPNMcA5SUTPK6qgrIs=";

  meta = {
    description = "OCI container runtime monitor written in Rust";
    homepage = "https://github.com/containers/conmon-rs";
    license = lib.licenses.asl20;
    teams = [ lib.teams.podman ];
    platforms = lib.platforms.linux;
  };
})
