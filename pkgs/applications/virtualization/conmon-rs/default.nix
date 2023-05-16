{ capnproto
, lib
, fetchFromGitHub
, protobuf
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "conmon-rs";
<<<<<<< HEAD
  version = "0.6.1";
=======
  version = "0.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-B8uloch+ucOLIIR64GE5Z8ahe2NLqPmDGcugQVSqpl4=";
=======
    sha256 = "sha256-mngs5ivRyMJ927VV00mFNIG+nD9EuE3qLyN+OHMMkHQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ capnproto protobuf ];
  doCheck = false;

<<<<<<< HEAD
  cargoHash = "sha256-hEhAnNppiyY6EcdHfri534ih8VUfpT7lO9L4mFJ6Caw=";
=======
  cargoSha256 = "sha256-ruChRz2rnPalBiXcpco/WS/eDgg52ckPBLBuoQa9us4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "An OCI container runtime monitor written in Rust";
    homepage = "https://github.com/containers/conmon-rs";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
