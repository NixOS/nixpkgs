{
  lib,
  stdenv,
  fetchFromGitHub,
  intltool,
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
  version = "5.7.0";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "qalculate-gtk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VPwPf1cQ7jGx9aGv4sjdwu945Nlh3ZqgH9dxtFxiMP4=";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [
    intltool
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

  meta = with lib; {
    description = "Ultimate desktop calculator";
    homepage = "http://qalculate.github.io";
    maintainers = with maintainers; [
      doronbehar
      pentane
      aleksana
    ];
    license = licenses.gpl2Plus;
    mainProgram = "qalculate-gtk";
    platforms = platforms.all;
  };
})
