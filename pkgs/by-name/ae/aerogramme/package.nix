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
    tag = version;
    hash = "sha256-ER+P/XGqNzTLwDLK5EBZq/Dl29ZZKl2FdxDb+oLEJ8Y=";
  };

  cargoPatches = [
    ./0001-update-time-rs.patch
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-GPj8qhfKgfAadQD9DJafN4ec8L6oY62PS/w/ljkPHpw=";

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
  };
}
