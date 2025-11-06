{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "kubernix";
  version = "0.2.0-unstable-2021-11-16";

  src = fetchFromGitHub {
    owner = "saschagrunert";
    repo = "kubernix";
    rev = "630087e023e403d461c4bb8b1c9368b26a2c0744";
    sha256 = "sha256-IkfVpNxWOqQt/aXsN4iD9dkKKyOui3maKowVibuKbvM=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  patches = [
    # Need a specific version of clap and clap_derive: fails with anything greater.
    ./Cargo.toml.patch
    # error: 1 positional argument in format string, but no arguments were given
    ./fix-compile-error.patch
  ];

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  doCheck = false;

  meta = with lib; {
    description = "Single dependency Kubernetes clusters for local testing, experimenting and development";
    mainProgram = "kubernix";
    homepage = "https://github.com/saschagrunert/kubernix";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ saschagrunert ];
    platforms = platforms.linux;
  };
}
