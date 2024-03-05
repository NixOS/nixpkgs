{ capnproto
, lib
, fetchFromGitHub
, protobuf
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "conmon-rs";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-B8uloch+ucOLIIR64GE5Z8ahe2NLqPmDGcugQVSqpl4=";
  };

  nativeBuildInputs = [ capnproto protobuf ];
  doCheck = false;

  cargoHash = "sha256-hEhAnNppiyY6EcdHfri534ih8VUfpT7lO9L4mFJ6Caw=";

  meta = with lib; {
    description = "An OCI container runtime monitor written in Rust";
    homepage = "https://github.com/containers/conmon-rs";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
