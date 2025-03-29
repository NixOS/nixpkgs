{ stdenv
, libsForQt5
, fetchFromGitLab
, makeDesktopItem
, fetchurl
, lib
, ...
}:

let
  pname = "cutentr";
  version = "0.3.3";

  icon = fetchurl {
    url = "https://gitlab.com/BoltsJ/cuteNTR/-/raw/${version}/setup/gui/com.gitlab.BoltsJ.cuteNTR.svg";
    hash = "sha256-bnSNJh13E2U11b+qW0SjfvZQ/VQi5Dbuz65g3svTgWo=";
  };

  desktopItem = makeDesktopItem {
    name = "cuteNTR";
    desktopName = "cuteNTR";
    icon = pname;
    exec = pname;
    categories = [ "Game" ];
  };
in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitLab {
    owner = "BoltsJ";
    repo = "cuteNTR";
    rev = "${version}";
    hash = "sha256-KfnC9R38qSMhQDeaMBWm1HoO3Wzs5kyfPFwdMZCWw4E=";
  };

  nativeBuildInputs = with libsForQt5.qt5; [
    wrapQtAppsHook
  ];

  buildInputs = with libsForQt5.qt5; [
    qtbase
  ];

  buildPhase = ''
    qmake
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r cutentr $out/bin

    install -m 444 -D "${desktopItem}/share/applications/"* \
      -t $out/share/applications/

    mkdir -p $out/share/icons/hicolor/"512"x"512"/apps
    cp ${icon} $out/share/icons/hicolor/"512"x"512"/apps/${pname}.svg
  '';

  meta = with lib; {
    description = "A 3DS streaming client for Linux";
    homepage = "https://gitlab.com/BoltsJ/cuteNTR";
    license = licenses.gpl3Only;
    mainProgram = "cutentr";
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.EarthGman ];
  };
}
