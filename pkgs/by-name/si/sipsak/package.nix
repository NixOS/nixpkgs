{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  c-ares,
  openssl,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sipsak";
  version = "0.9.8.1-unstable-2023-06-02";

  src = fetchFromGitHub {
    owner = "nils-ohlmeier";
    repo = "sipsak";
    rev = "ed6a911f07012c9fdf7f5a27970bb5fc0ee541fb";
    hash = "sha256-YoiBg6hvuUbo7VnnP4JJJCkmSjxBhtlNpWq/5XzYK7E=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    openssl
    c-ares
  ];

  env.NIX_CFLAGS_COMPILE = "-std=gnu89";

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    homepage = "https://github.com/nils-ohlmeier/sipsak";
    description = "SIP Swiss army knife";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = with lib.platforms; unix;
    mainProgram = "sipsak";
  };
})
