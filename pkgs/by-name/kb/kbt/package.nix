{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  libx11,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kbt";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "bloznelis";
    repo = "kbt";
    rev = finalAttrs.version;
    hash = "sha256-ROCZDa5eyGF9yE+zdZ4snzdz8+jk+H6ZnqsnCe8JtJw=";
  };

  cargoHash = "sha256-wG1uB/oOUUAQVpGXe7sTqt9tLmFoLrOAmeat/d1xOM8=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libx11
  ];

  meta = {
    description = "Keyboard tester in terminal";
    homepage = "https://github.com/bloznelis/kbt";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "kbt";
  };
})
