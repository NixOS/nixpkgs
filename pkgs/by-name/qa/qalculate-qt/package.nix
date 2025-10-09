{
  lib,
  stdenv,
  fetchFromGitHub,
  intltool,
  pkg-config,
  qt6,
  libqalculate,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qalculate-qt";
  version = "5.7.0";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "qalculate-qt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FvPJLPG5rFd7I3RTEQsLZ7bY9qWnMb32PUYAuiCbA8s=";
  };

  nativeBuildInputs = with qt6; [
    qmake
    intltool
    pkg-config
    qttools
    wrapQtAppsHook
  ];
  buildInputs =
    with qt6;
    [
      libqalculate
      qtbase
      qtsvg
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ qtwayland ];

  postPatch = ''
    substituteInPlace qalculate-qt.pro\
      --replace "LRELEASE" "${qt6.qttools.dev}/bin/lrelease"
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    mv $out/bin/qalculate-qt.app $out/Applications
    makeWrapper $out/{Applications/qalculate-qt.app/Contents/MacOS,bin}/qalculate-qt
  '';

  meta = with lib; {
    description = "Ultimate desktop calculator";
    homepage = "http://qalculate.github.io";
    maintainers = [ ];
    license = licenses.gpl2Plus;
    mainProgram = "qalculate-qt";
    platforms = platforms.unix;
  };
})
