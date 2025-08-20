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

  cargoHash = "sha256-u8sJS9hvIao+af7IA4vE0eUSx0xmI1Kb5NXyZBrOCIw=";

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
