{ stdenv, fetchFromGitHub
, qtbase, qtwebengine
, qmakeHook }:

stdenv.mkDerivation rec {
  version = "0.5.5rc2";
  name = "qsyncthingtray-${version}";

  src = fetchFromGitHub {
    owner = "sieren";
    repo = "QSyncthingTray";
    rev = "${version}";
    sha256 = "1x7j7ylgm4ih06m7gb5ls3c9bdjwbra675489caq2f04kgw4yxq2";
  };

  buildInputs = [ qtbase qtwebengine ];
  nativeBuildInputs = [ qmakeHook ];
  enableParallelBuilding = true;
  
  postInstall = ''
    mkdir -p $out/bin
    cp binary/QSyncthingTray $out/bin
    cat > $out/bin/qt.conf <<EOF
    [Paths]
    Prefix = ${qtwebengine.out}
    EOF
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
  };
}
