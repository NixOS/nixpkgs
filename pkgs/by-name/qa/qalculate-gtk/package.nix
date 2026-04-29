{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libqalculate,
  gtk3,
  curl,
  wrapGAppsHook3,
  desktopToDarwinBundle,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qalculate-gtk";
  version = "5.10.0";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "qalculate-gtk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JZfolSRLRLtv529f25lEPYOlz+y+EdRqKA0Y5d1dK3s=";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  buildInputs = [
    libqalculate
    gtk3
    curl
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Ultimate desktop calculator";
    homepage = "http://qalculate.github.io";
    maintainers = with lib.maintainers; [
      doronbehar
      pentane
      aleksana
    ];
    license = lib.licenses.gpl2Plus;
    mainProgram = "qalculate-gtk";
    platforms = lib.platforms.all;
  };
})
