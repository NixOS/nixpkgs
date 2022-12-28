{ capnproto
, lib
, fetchFromGitHub
, protobuf
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "conmon-rs";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VwVJWf9tKZ5rVF8tXDf35zsS2PipqC8FPbXUpOzsw/Y=";
  };

  nativeBuildInputs = [ capnproto protobuf ];
  doCheck = false;

  cargoSha256 = "sha256-zY9fsZK1C3HnCxeNA5dCbQQHYx3IVDMHCHYwFh5ev2k=";

  meta = with lib; {
    description = "An OCI container runtime monitor written in Rust";
    homepage = "https://github.com/containers/conmon-rs";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
