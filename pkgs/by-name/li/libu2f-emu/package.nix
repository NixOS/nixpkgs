{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  autoconf-archive,
  pkg-config,
  openssl,
  gtest,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "libu2f-emu";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "eveldun";
    repo = "libu2f-emu";
    tag = version;
    hash = "sha256-VExtT1AFJUTNlZ+MdnwpbnY8lMaAtg7q5fD9inVdgK4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
  ];

  buildInputs = [ openssl ];

  checkInputs = [ gtest ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Universal 2nd Factor (U2F) Emulation C Library";
    homepage = "https://github.com/eveldun/libu2f-emu";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ners ];
  };
}
