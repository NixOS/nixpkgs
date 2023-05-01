{ lib
, stdenv
, env
, fetchFromGitHub
, pkg-config
, qbs
, wrapQtAppsHook
, qtbase
, qtdeclarative
, qttools
, qtsvg
, zlib
, libGL
}:

let
  qtEnv = env "tiled-qt-env" [ qtbase qtdeclarative qtsvg qttools ];
in

stdenv.mkDerivation rec {
  pname = "tiled";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "mapeditor";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zrDka6yXJ++UuGFepn8glQ1r7ufBcjsnNZuH+jnkJw0=";
  };

  nativeBuildInputs = [ pkg-config qbs wrapQtAppsHook ];
  buildInputs = [ qtEnv zlib libGL ];

  outputs = [ "out" "dev" ];

  strictDeps = true;

  configurePhase = ''
    runHook preConfigure

    qbs setup-qt --settings-dir . ${qtEnv}/bin/qmake qtenv
    qbs config --settings-dir . defaultProfile qtenv
    qbs resolve --settings-dir . config:release qbs.installPrefix:/ projects.Tiled.installHeaders:true

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    qbs build --settings-dir . config:release

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    qbs install --settings-dir . --install-root $out config:release

    runHook postInstall
  '';

  meta = with lib; {
    description = "Free, easy to use and flexible tile map editor";
    homepage = "https://www.mapeditor.org/";
    license = with licenses; [
      bsd2	# libtiled and tmxviewer
      gpl2Plus	# all the rest
    ];
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.linux;
  };
}
