{
  capnproto,
  lib,
  fetchFromGitHub,
  protobuf,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "conmon-rs";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "conmon-rs";
    rev = "v${version}";
    hash = "sha256-fs+IcibhyoC5+Sbr9lWtBbb0Sk6Uf+YVockXNbCLXCY=";
  };

  nativeBuildInputs = [
    capnproto
    protobuf
  ];
  doCheck = false;

  cargoHash = "sha256-l+FcrLPE+EGb3IEWikUJ1Ak8lOSlYz9WvUffGHzU0tc=";

  meta = with lib; {
    description = "OCI container runtime monitor written in Rust";
    homepage = "https://github.com/containers/conmon-rs";
    license = licenses.asl20;
    teams = [ teams.podman ];
    platforms = platforms.linux;
  };
}
