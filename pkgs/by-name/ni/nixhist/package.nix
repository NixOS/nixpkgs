{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "nixhist";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "daskladas";
    repo = "nixhist";
    rev = "v${version}";
    hash = "sha256-Y7GisoFi96I9JeuNw4aKZpfcEZp13A8NfS5vzfsR9Mk=";
  };

  cargoHash = "sha256-/7JHIU0REuEaPWPSAM5QsW0d6dZz+cCfhlX1ytUH5Lc=";
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    xorg.libxcb
  ];

  meta = {
    description = "A TUI for viewing, comparing, and managing NixOS generations";
    homepage = "https://github.com/daskladas/nixhist";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "nixhist";
    platforms = lib.platforms.linux;
  };
}
