{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  tokyocabinet,
  ncurses,
  cairo ? null,
  pango ? null,
  enableCairo ? stdenv.hostPlatform.isLinux,
}:

assert enableCairo -> cairo != null && pango != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "duc";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "zevv";
    repo = "duc";
    rev = finalAttrs.version;
    sha256 = "sha256-hZ8bhPXS/trt6ZePjfuwx8PEfv0xCBqSJxRonLB7Ui0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    tokyocabinet
    ncurses
  ]
  ++ lib.optionals enableCairo [
    cairo
    pango
  ];

  configureFlags = lib.optionals (!enableCairo) [
    "--disable-x11"
    "--disable-cairo"
  ];

  meta = {
    homepage = "http://duc.zevv.nl/";
    description = "Collection of tools for inspecting and visualizing disk usage";
    license = lib.licenses.gpl2Only;

    platforms = lib.platforms.all;
    maintainers = [ ];
    mainProgram = "duc";
  };
})
