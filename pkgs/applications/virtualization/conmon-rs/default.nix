{ capnproto
, lib
, fetchFromGitHub
, protobuf
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "conmon-rs";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+RKjJtI01Y56+cFDdOSAL4BodI7R/rM3B3ht3p6+xzs=";
  };

  nativeBuildInputs = [ capnproto protobuf ];
  doCheck = false;

  cargoHash = "sha256-4VOse+y0EO9IORyeAO/j1t6ssQARJp7lK21TUJVuH78=";

  meta = with lib; {
    description = "An OCI container runtime monitor written in Rust";
    homepage = "https://github.com/containers/conmon-rs";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
