{
  lib,
  rustPlatform,
  fetchCrate,
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

  buildCAPIOnly = true;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = with lib; {
    description = "C library for Dolby Vision metadata parsing and writing";
    homepage = "https://crates.io/crates/dolby_vision";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
    pkgConfigModules = [ "dovi" ];
  };
}
