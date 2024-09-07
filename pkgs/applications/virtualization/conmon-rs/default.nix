{ capnproto
, lib
, fetchFromGitHub
, protobuf
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "conmon-rs";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qb7n6AcRkv/nF0BQbPgdFqaklfJeC+PRzMh6EIykobY=";
  };

  nativeBuildInputs = [ capnproto protobuf ];
  doCheck = false;

  cargoVendorDir = ".cargo-vendor";

  meta = with lib; {
    description = "OCI container runtime monitor written in Rust";
    homepage = "https://github.com/containers/conmon-rs";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
