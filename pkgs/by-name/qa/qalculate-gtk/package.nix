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
  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "qalculate-gtk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0+c6zInEorUH3Fd4qRJD1pXeAGsK6EY53qQAu3ctGKg=";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [
    intltool
    pkg-config
    autoreconfHook
    wrapGAppsHook3
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];
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
      gebner
      doronbehar
      alyaeanyx
    ];
    license = licenses.gpl2Plus;
    mainProgram = "qalculate-gtk";
    platforms = platforms.all;
  };
})
