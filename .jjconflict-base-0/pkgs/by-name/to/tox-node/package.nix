{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "tox-node";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "tox-rs";
    repo = "tox";
    rev = "v${version}";
    sha256 = "sha256-3ZRpri3WxwHjMq88TxRJAaTXMui8N1uLek+q8g5PGD4=";
  };

  buildAndTestSubdir = "tox_node";

  useFetchCargoVendor = true;
  cargoHash = "sha256-UNvhls6qY1u9STr8PsgcUfFYRDTlqvxB3M57j/fdkH8=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Server application to run tox node written in pure Rust";
    homepage = "https://github.com/tox-rs/tox";
    license = [ licenses.gpl3Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [
      suhr
      kurnevsky
    ];
    mainProgram = "tox-node";
  };
}
