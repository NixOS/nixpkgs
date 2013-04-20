{ stdenv, fetchurl, cmake, lame, id3lib, libvorbis, qt4, libogg }:

stdenv.mkDerivation {
  name = "skype-call-recorder-0.8";
  src = fetchurl {
    url = "http://atdot.ch/scr/files/0.8/skype-call-recorder-0.8.tar.gz";
    sha256 = "1iijkhq3aj9gr3bx6zl8ryvzkqcdhsm9yisimakwq0lnw0lgf5di";
  };

  # Keep an rpath reference to the used libogg
  prePatch = ''
    sed -i -e '/ADD_EXECUTABLE/aSET(LIBRARIES ''${LIBRARIES} ogg)' CMakeLists.txt
  '';

  # Better support for hosted conferences
  patches = [ ./conference.patch ];

  buildInputs = [ cmake lame id3lib libvorbis qt4 libogg ];

  meta = {
    homepage = http://atdot.ch/scr/;
    description = "Open source tool to record your Skype calls on Linux";
    license = "GPLv2+";
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
