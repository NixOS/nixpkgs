{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "qwt-multiaxes";
  version = "0-unstable-2024-02-20";

  src = fetchFromGitHub {
    owner = "cseci";
    repo = "qwt";
    rev = "34c2c7e45ef7fafb15a9126f0aa71d2c7ad1efcd";
    hash = "sha256-jDoAs5OTM6rKVIqE/B/eSMDHeb8/ClY4ReeEnH2TZ6s=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtsvg
  ];

  postPatch =
    let
      out = placeholder "out";
      dev = placeholder "dev";
    in
    ''
      substituteInPlace qwtconfig.pri \
        --replace-fail '/usr/local/qwt-$$QWT_VERSION-ma' '${out}' \
        --replace-fail 'QWT_INSTALL_DOCS      = $${QWT_INSTALL_PREFIX}/doc' 'QWT_INSTALL_DOCS      = ${dev}/share/doc/qwt' \
        --replace-fail 'QWT_INSTALL_HEADERS   = $${QWT_INSTALL_PREFIX}/include' 'QWT_INSTALL_HEADERS   = ${dev}/include' \
        --replace-fail 'QWT_INSTALL_FEATURES  = $${QWT_INSTALL_PREFIX}/features' 'QWT_INSTALL_FEATURES  = ${dev}/features'
    '';

  qmakeFlags = [
    "QWT_CONFIG+=QwtPlot"
    "QWT_CONFIG+=QwtWidgets"
    "QWT_CONFIG+=QwtSvg"
    "QWT_CONFIG+=QwtOpenGL"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch=qwt-multiaxes-updated" ];
  };

  meta = {
    description = "Qt Widgets for Technical Applications with multi-axes support";
    homepage = "https://github.com/cseci/qwt";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ imadnyc ];
    platforms = lib.platforms.linux;
  };
}
