{ stdenv, fetchFromGitHub, qt5, makeDesktopItem }:

let
  description = "A note-taking application that knows programmers and Markdown better";
  desktopItem = makeDesktopItem {
    name = "VNote";
    exec = "vnote";
    icon = "vnote";
    comment = description;
    desktopName = "VNote";
    categories = "Office";
  };
in stdenv.mkDerivation rec {
  version = "2.5";
  name = "vnote-${version}";

  src = fetchFromGitHub {
    owner = "tamlok";
    repo = "vnote";
    fetchSubmodules = true;
    rev = "8d780bd5898464139e252623ffaccd966e093ff1";
    sha256 = "17nl4z1k24wfl18f6fxs2chsmxc2526ckn5pddi2ckirbiwqwm60";
  };

  configurePhase = ''
    mkdir build
    cd build
    qmake ../VNote.pro
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./src/VNote $out/bin/vnote

    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications

    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp ../src/resources/icons/vnote.svg $out/share/icons/hicolor/scalable/apps/vnote.svg
    mkdir -p $out/share/icons/hicolor/16x16/apps
    cp ../src/resources/icons/16x16/vnote.png $out/share/icons/hicolor/16x16/apps/vnote.png
    mkdir -p $out/share/icons/hicolor/32x32/apps
    cp ../src/resources/icons/32x32/vnote.png $out/share/icons/hicolor/32x32/apps/vnote.png
    mkdir -p $out/share/icons/hicolor/48x48/apps
    cp ../src/resources/icons/48x48/vnote.png $out/share/icons/hicolor/48x48/apps/vnote.png
    mkdir -p $out/share/icons/hicolor/64x64/apps
    cp ../src/resources/icons/64x64/vnote.png $out/share/icons/hicolor/64x64/apps/vnote.png
    mkdir -p $out/share/icons/hicolor/128x128/apps
    cp ../src/resources/icons/128x128/vnote.png $out/share/icons/hicolor/128x128/apps/vnote.png
    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp ../src/resources/icons/256x256/vnote.png $out/share/icons/hicolor/256x256/apps/vnote.png
  '';

  buildInputs = [ qt5.full ];

  meta = with stdenv.lib; {
    inherit description;
    homepage = https://tamlok.github.io/vnote;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.kuznero ];
  };
}
