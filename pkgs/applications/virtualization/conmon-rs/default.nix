{ capnproto
, lib
, fetchFromGitHub
, protobuf
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "conmon-rs";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mngs5ivRyMJ927VV00mFNIG+nD9EuE3qLyN+OHMMkHQ=";
  };

  nativeBuildInputs = [ capnproto protobuf ];
  doCheck = false;

  cargoSha256 = "sha256-ruChRz2rnPalBiXcpco/WS/eDgg52ckPBLBuoQa9us4=";

  meta = with lib; {
    description = "An OCI container runtime monitor written in Rust";
    homepage = "https://github.com/containers/conmon-rs";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
