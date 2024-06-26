{
  lib,
  stdenv,
  fetchFromGitHub,
  wrapQtAppsHook,
  qmake,
  qtmultimedia,
}:

stdenv.mkDerivation rec {
  pname = "kristall";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "MasterQ32";
    repo = "kristall";
    rev = "V${version}";
    sha256 = "07nf7w6ilzs5g6isnvsmhh4qa1zsprgjyf0zy7rhpx4ikkj8c8zq";
  };

  postPatch = lib.optionalString stdenv.cc.isClang ''
    sed -i '1i #include <errno.h>' src/browsertab.cpp
  '';

  nativeBuildInputs = [
    wrapQtAppsHook
    qmake
  ];

  buildInputs = [ qtmultimedia ];

  qmakeFlags = [ "src/kristall.pro" ];

  installPhase =
    if stdenv.isDarwin then
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

  meta = with lib; {
    description = "Graphical small-internet client, supports gemini, http, https, gopher, finger";
    mainProgram = "kristall";
    homepage = "https://random-projects.net/projects/kristall.gemini";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.gpl3Only;
    inherit (qtmultimedia.meta) platforms;
  };
}
