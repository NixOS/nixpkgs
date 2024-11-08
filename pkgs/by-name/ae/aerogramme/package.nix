{
  lib,
  rustPlatform,
  fetchgit,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "aerogramme";
  version = "0.3.0";

  src = fetchgit {
    url = "https://git.deuxfleurs.fr/Deuxfleurs/aerogramme/";
    rev = "refs/tags/${version}";
    hash = "sha256-ER+P/XGqNzTLwDLK5EBZq/Dl29ZZKl2FdxDb+oLEJ8Y=";
  };

  cargoPatches = [
    ./0001-update-time-rs.patch
  ];

  # must use our own Cargo.lock due to git dependencies
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "imap-codec-2.0.0" = "sha256-o64Q74Q84xLRfU4K4JtcjyS0J8mfoApvUs9siscd0RA=";
      "imap-flow-0.1.0" = "sha256-IopxybuVt5OW6vFiw/4MxojzaNZrKu2xyfaX6F8IYlA=";
      "k2v-client-0.0.4" = "sha256-V71FCIsgK3VStFOzVntm8P0vXRobF5rQ74qar+cKyik=";
      "smtp-message-0.1.0" = "sha256-FoSakm3D1xg1vefLf/zkyvzsij1G0QstK3CRo+LbByE=";
    };
  };

  # disable network tests as Nix sandbox breaks them
  doCheck = false;

  env = {
    # get openssl-sys to use pkg-config
    OPENSSL_NO_VENDOR = true;
    RUSTC_BOOTSTRAP = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = {
    description = "Encrypted e-mail storage over Garage";
    homepage = "https://aerogramme.deuxfleurs.fr/";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ supinie ];
    mainProgram = "aerogramme";
    platforms = lib.platforms.linux;
    broken = true; # https://github.com/rust-lang/rust/issues/129811
  };
}
