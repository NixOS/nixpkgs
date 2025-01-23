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
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "rochacbruno";
    repo = "marmite";
    tag = version;
    hash = "sha256-AblitYe7YDUc2Tg2P7j+wnOjMAhDtieDsbq6B6x+uMs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-gVFyhWVtj9zU0FEGeN+BI0hvz0qSH5dCz1/d/i9wCyo=";

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
