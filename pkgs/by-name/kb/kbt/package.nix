{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "kbt";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "bloznelis";
    repo = "kbt";
    rev = version;
    hash = "sha256-ROCZDa5eyGF9yE+zdZ4snzdz8+jk+H6ZnqsnCe8JtJw=";
  };

  cargoHash = "sha256-wG1uB/oOUUAQVpGXe7sTqt9tLmFoLrOAmeat/d1xOM8=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    xorg.libX11
  ];

  meta = with lib; {
    description = "Keyboard tester in terminal";
    homepage = "https://github.com/bloznelis/kbt";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "kbt";
  };
}
