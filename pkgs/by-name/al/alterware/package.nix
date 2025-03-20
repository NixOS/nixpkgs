{ lib, fetchFromGitHub, rustPlatform, perl, }:

with import (fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.11") {
  overlays = [
    (import (fetchTarball
      "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
  ];
};
let
  rustPlatform = makeRustPlatform {
    cargo = rust-bin.stable.latest.minimal;
    rustc = rust-bin.stable.latest.minimal;
  };
  # The above is needed until the rustc version is at least 1.78 in rustPlatform.buildRustPackage.

in rustPlatform.buildRustPackage rec {
  pname = "alterware";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "mxve";
    repo = "alterware-launcher";
    rev = "v${version}";
    sha256 = "1sqh40jhdcbd5nr8lzjqkj4zdg9r2l5cfda3cv6dhwx46qm180gd";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-E3TDgEogpd/YGZnQmre5igxZyZdKQtOx4O4IZEci5II=";

  nativeBuildInputs = [ perl ];

  meta = {
    description = "Official launcher for AlterWare Call of Duty mods";
    homepage = "https://github.com/mxve/alterware-launcher";
    license = lib.licenses.gpl3Only;
    maintainers = [ andrew-field ];
    mainProgram = "alterware";
  };
}
