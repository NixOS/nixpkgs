{
  lib,
  stdenv,
  fetchFromGitHub,
  intltool,
  pkg-config,
  qmake,
  wrapQtAppsHook,
  libqalculate,
  qtbase,
  qttools,
  qtsvg,
  qtwayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qalculate-qt";
  version = "5.2.0.1";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "qalculate-qt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kzOxOCZmu4mYYgegRBU8SMAkTiE4p1AugVAeZa8yDDE=";
  };

  nativeBuildInputs = [
    qmake
    intltool
    pkg-config
    qttools
    wrapQtAppsHook
  ];
  buildInputs = [
    libqalculate
    qtbase
    qtsvg
  ] ++ lib.optionals stdenv.isLinux [ qtwayland ];

  postPatch = ''
    substituteInPlace qalculate-qt.pro\
      --replace "LRELEASE" "${qttools.dev}/bin/lrelease"
  '';

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv $out/bin/qalculate-qt.app $out/Applications
    makeWrapper $out/{Applications/qalculate-qt.app/Contents/MacOS,bin}/qalculate-qt
  '';

  meta = with lib; {
    description = "Ultimate desktop calculator";
    homepage = "http://qalculate.github.io";
    maintainers = with maintainers; [ _4825764518 ];
    license = licenses.gpl2Plus;
    mainProgram = "qalculate-qt";
    platforms = platforms.unix;
  };
})
