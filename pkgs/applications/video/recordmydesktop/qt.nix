{ stdenv, lib, fetchsvn, recordmydesktop, autoreconfHook, pkgconfig
, glib, pythonPackages, qt4, jack2, xwininfo }:

let
  binPath = lib.makeBinPath [ recordmydesktop jack2 xwininfo ];

in stdenv.mkDerivation rec {
  name = "qt-recordmydesktop-${version}";
  version = "0.3.8-svn${recordmydesktop.rev}";

  src = fetchsvn {
    url = https://recordmydesktop.svn.sourceforge.net/svnroot/recordmydesktop/trunk/qt-recordmydesktop;
    inherit (recordmydesktop) rev;
    sha256 = "0vz7amrmz317sbx2cv2186d0r57as4l26xa9rpim5gbvzk20caqc";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ glib qt4 ] ++ (with pythonPackages; [
    python wrapPython pyqt4
  ]);

  pythonPath = with pythonPackages; [ pyqt4 ];

  postInstall = ''
    makeWrapperArgs="--prefix PATH : ${binPath}"
    wrapPythonPrograms
  '';

  meta = with stdenv.lib; {
    description = "GTK frontend for recordmydesktop";
    homepage = http://recordmydesktop.sourceforge.net/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.DamienCassou ];
  };
}
