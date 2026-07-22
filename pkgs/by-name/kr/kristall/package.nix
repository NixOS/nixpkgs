{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
}:

stdenv.mkDerivation rec {
  pname = "kristall";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "MasterQ32";
    repo = "kristall";
    rev = "V${version}";
    hash = "sha256-zTO55xTc7hXlqVUVlx921+LalKj/yQwjEgXW2YUdG70=";
  };

  postPatch = lib.optionalString stdenv.cc.isClang ''
    sed -i '1i #include <errno.h>' src/browsertab.cpp
  '';

  nativeBuildInputs = [
    libsForQt5.wrapQtAppsHook
    libsForQt5.qmake
    libsForQt5.qttools
  ];

  buildInputs = [ libsForQt5.qtmultimedia ];

  qmakeFlags = [ "src/kristall.pro" ];

  installPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p $out/Applications
        mv kristall.app $out/Applications
      ''
    else
      ''
        install -Dt $out/bin kristall
        install -D Kristall.desktop $out/share/applications/net.random-projects.kristall.desktop
        install -D src/icons/kristall.svg $out/share/icons/hicolor/scalable/apps/net.random-projects.kristall.svg
        for size in 16 32 64 128; do
          install -D src/icons/kristall-''${size}.png $out/share/icons/hicolor/''${size}x''${size}/apps/net.random-projects.kristall.png
        done
      '';

  meta = {
    description = "Graphical small-internet client, supports gemini, http, https, gopher, finger";
    mainProgram = "kristall";
    homepage = "https://random-projects.net/projects/kristall.gemini";
    license = lib.licenses.gpl3Only;
    inherit (libsForQt5.qtmultimedia.meta) platforms;
  };
}
