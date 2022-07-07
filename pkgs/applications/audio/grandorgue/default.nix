{ lib, stdenv, fetchsvn, cmake, gcc, pkg-config, fftwFloat, alsa-lib
, zlib, wavpack, wxGTK31, udev, jackaudioSupport ? false, libjack2
, includeDemo ? true }:

stdenv.mkDerivation rec {
  pname = "grandorgue";
  rev = "2333";
  version = "0.3.1-r${rev}";
  src = fetchsvn {
    url = "https://svn.code.sf.net/p/ourorgan/svn/trunk";
    inherit rev;
    sha256 = "0xzjdc2g4gja2lpmn21xhdskv43qpbpzkbb05jfqv6ma2zwffzz1";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ pkg-config fftwFloat alsa-lib zlib wavpack wxGTK31 udev ]
    ++ lib.optional jackaudioSupport libjack2;

  cmakeFlags = lib.optional (!jackaudioSupport) [
    "-DRTAUDIO_USE_JACK=OFF"
    "-DRTMIDI_USE_JACK=OFF"
  ] ++ lib.optional (!includeDemo) "-DINSTALL_DEMO=OFF";

  meta = {
    description = "Virtual Pipe Organ Software";
    homepage = "https://sourceforge.net/projects/ourorgan";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.puzzlewolf ];
  };
}
