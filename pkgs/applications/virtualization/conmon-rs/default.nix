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
    hash = "sha256-+htd9RJGSFzzyEQSBJGIzurQDQgpJ+sJHLPe3aPH0cg=";
  };

  nativeBuildInputs = [ capnproto protobuf ];
  doCheck = false;

  cargoHash = "sha256-CcWji/qMd7eX0O3cR9/FLID17WpSfz4kEAhDgKb3jds=";

  meta = with lib; {
    description = "An OCI container runtime monitor written in Rust";
    homepage = "https://github.com/containers/conmon-rs";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
