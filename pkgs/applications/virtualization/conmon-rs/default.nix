{ capnproto
, lib
, fetchFromGitHub
, protobuf
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "conmon-rs";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YaSc1sAXK50BDaLABb00MlrN/qXhJtZ3f2wkUHS8S9U=";
  };

  nativeBuildInputs = [ capnproto protobuf ];
  doCheck = false;

  cargoHash = "sha256-b3xIMItg9yOesyf7p8XzgCZpSsyIVMGv6/kJbg5gKoU=";

  meta = with lib; {
    description = "An OCI container runtime monitor written in Rust";
    homepage = "https://github.com/containers/conmon-rs";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
