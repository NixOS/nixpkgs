{ pkgs ? import <nixpkgs> {} }:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "rustrland";
  version = "0.3.2";

  src = pkgs.fetchFromGitHub {
    owner = "mattdef";
    repo = "rustrland";
    rev = "v${version}";
    sha256 = "sha256-sT4XSYrBxjVTd+xMcCqi24k/TbIRX4p8lEgrf/Wj1z8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  # Skip building examples that have compilation issues
  cargoBuildFlags = [ "--bins" ];
  cargoTestFlags = [ "--bins" ];

  meta = with pkgs.lib; {
    description = "A Rust-powered window management for Hyprland - Fast, reliable plugin system";
    homepage = "https://github.com/mattdef/rustrland";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
