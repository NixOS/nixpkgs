{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  libvorbis,
  speex,
  flac,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfishsound";
  version = "1.0.1";

  src = fetchurl {
    url = "https://downloads.xiph.org/releases/libfishsound/libfishsound-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-A+sWAeIwatyIx3av3yEiF8ZUeZDS0PnKVE2tmoqdu48=";
  };

  propagatedBuildInputs = [
    libvorbis
    speex
    flac
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  meta = {
    homepage = "https://xiph.org/fishsound/";
    description = "Simple programming interface for decoding and encoding audio data using Xiph.org codecs (FLAC, Speex and Vorbis)";
    longDescription = ''
      libfishsound by itself is designed to handle raw codec streams from a lower level layer such as UDP datagrams. When these codecs are used in files, they are commonly encapsulated in Ogg to produce Ogg FLAC, Speex and Ogg Vorbis files.

      libfishsound is a wrapper around the existing codec libraries and provides a consistent, higher-level programming interface. It has been designed for use in a wide variety of applications; it has no direct dependencies on Ogg encapsulation, though it is most commonly used in conjunction with liboggz to decode or encode FLAC, Speex or Vorbis audio tracks in Ogg files, including Ogg Theora and Annodex.

      FishSound has been developed and tested on GNU/Linux, Darwin/MacOSX and Win32. It probably also works on other Unix-like systems via GNU autoconf. For Win32: nmake Makefiles, Visual Studio .NET 2003 solution files and Visual C++ 6.0 workspace files are all provided in the source distribution.
    '';
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
  };
})
