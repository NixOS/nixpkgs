{
  capnproto,
  lib,
  fetchFromGitHub,
  protobuf,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "conmon-rs";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "conmon-rs";
    rev = "v${version}";
    hash = "sha256-NydA6IiIGX2Pc/49bstEGeA/X+zRIVNGbxhDfPwrWgM=";
  };

  nativeBuildInputs = [
    capnproto
    protobuf
  ];
  doCheck = false;

  cargoHash = "sha256-qP4AIPST1s6fiGq6FM2aXpEfkm4G/cOSYJyhtqF2k1E=";

  meta = with lib; {
    description = "OCI container runtime monitor written in Rust";
    homepage = "https://github.com/containers/conmon-rs";
    license = licenses.asl20;
    teams = [ teams.podman ];
    platforms = platforms.linux;
  };
}
