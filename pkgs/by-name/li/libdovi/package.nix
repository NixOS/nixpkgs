{
  lib,
  rustPlatform,
  fetchCrate,
  cargo-c,
}:

rustPlatform.buildRustPackage rec {
  pname = "libdovi";
  version = "3.3.1";

  src = fetchCrate {
    pname = "dolby_vision";
    inherit version;
    hash = "sha256-ecd+r0JWZtP/rxt4Y3Cj2TkygXIMy5KZhZpXBwJNPx4=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  dontCargoBuild = true;
  dontCargoInstall = true;
  dontCargoCheck = true;

  nativeBuildInputs = [ cargo-c ];

  meta = {
    description = "C library for Dolby Vision metadata parsing and writing";
    homepage = "https://crates.io/crates/dolby_vision";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
