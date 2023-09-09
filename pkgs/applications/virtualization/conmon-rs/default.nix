{ capnproto
, lib
, fetchFromGitHub
, protobuf
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "conmon-rs";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RQ3cVM7aEuCCmOCr4UWkxBMr66tdYFl0nNO7tXY05vE=";
  };

  # Cargo.lock is out of date for this release.
  cargoPatches = [ ./Cargo.lock.patch ];

  nativeBuildInputs = [ capnproto protobuf ];
  doCheck = false;

  cargoHash = "sha256-BNowZkD+y1jh25EvfhQzvT5BZzrq46KBd69AJ//9enE=";

  meta = with lib; {
    description = "An OCI container runtime monitor written in Rust";
    homepage = "https://github.com/containers/conmon-rs";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
