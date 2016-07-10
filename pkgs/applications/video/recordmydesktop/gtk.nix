{ stdenv, lib, fetchsvn, recordmydesktop, autoreconfHook, pkgconfig, glib
, pythonPackages, jack2, xwininfo }:

let
  binPath = lib.makeBinPath [ recordmydesktop jack2 xwininfo ];

in stdenv.mkDerivation rec {
  name = "gtk-recordmydesktop-${version}";
  version = "0.3.8-svn${recordmydesktop.rev}";

  src = fetchsvn {
    url = https://recordmydesktop.svn.sourceforge.net/svnroot/recordmydesktop/trunk/gtk-recordmydesktop;
    inherit (recordmydesktop) rev;
    sha256 = "010aykgjfxhyiixq9a9fg3p1a1ixz59m1vkn16hpy0lybgf4dsby";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = with pythonPackages; [
    python pygtk wrapPython
  ];

  pythonPath = with pythonPackages; [ pygtk ];

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
