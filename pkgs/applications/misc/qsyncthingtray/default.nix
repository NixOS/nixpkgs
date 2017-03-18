{ stdenv, fetchFromGitHub
, qtbase, qtwebengine
, qmakeHook }:

stdenv.mkDerivation rec {
  version = "0.5.7";
  name = "qsyncthingtray-${version}";

  src = fetchFromGitHub {
    owner = "sieren";
    repo = "QSyncthingTray";
    rev = "${version}";
    sha256 = "0crrdpdmlc4ahkvp5znzc4zhfwsdih655q1kfjf0g231mmynxhvq";
  };

  buildInputs = [ qtbase qtwebengine ];
  nativeBuildInputs = [ qmakeHook ];
  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out/bin
    cp binary/QSyncthingTray $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/sieren/QSyncthingTray/;
    description = "A Traybar Application for Syncthing written in C++";
    longDescription = ''
        A cross-platform status bar for Syncthing.
        Currently supports OS X, Windows and Linux.
        Written in C++ with Qt.
    '';
    license = licenses.lgpl3;
    maintainers = with maintainers; [ zraexy ];
    platforms = platforms.all;
    broken = builtins.compareVersions qtbase.version "5.7.0" >= 0;
  };
}
