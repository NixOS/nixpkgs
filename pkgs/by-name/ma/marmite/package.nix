{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "marmite";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "rochacbruno";
    repo = "marmite";
    tag = version;
    hash = "sha256-IfmwPN2PbBXJJXHgwseC5L3sDOjaVlRE//H8uHazSNA=";
  };

  cargoHash = "sha256-FpCoSX/V7AoRED3bFoGLqyNsS1mNK8i2z+YjWMvtUZo=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  meta = {
    description = "Static Site Generator for Blogs";
    homepage = "https://github.com/rochacbruno/marmite";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "marmite";
  };
}
