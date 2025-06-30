{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  libvorbis,
  speex,
  flac,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "libfishsound";
  version = "1.0.0";

  src = fetchurl {
    url = "https://downloads.xiph.org/releases/libfishsound/${pname}-${version}.tar.gz";
    sha256 = "1iz7mn6hw2wg8ljaw74f4g2zdj68ib88x4vjxxg3gjgc5z75f2rf";
  };

  patches =
    let
      fetchDebPatch =
        { name, hash }:
        fetchpatch {
          inherit name hash;
          url = "https://salsa.debian.org/multimedia-team/libfishsound/-/raw/f25f31a13dd2ce008614427889b08e6f2222898f/debian/patches/${name}";
        };
    in
    map fetchDebPatch [
      {
        name = "0001-Patch-configure.ac-to-specify-config-macro-dir.patch";
        hash = "sha256-3cijMhgxqwFisc5nt8826QUwOqPI7H425QkDcjnD4iM=";
      }
      {
        name = "0002-flac-set-vendor_string.length-0.patch";
        hash = "sha256-8195rU9IAhFL3MgB4jLwtJv6BWgz22A38+RmIymIQoo=";
      }
      {
        name = "0003-Fix-incompatible-flac-callback-types.patch";
        hash = "sha256-BxG1hlThzhJ6VeGcsNpDEtVyKSJTLGFKeHFpFoXW54A=";
      }
    ];

  propagatedBuildInputs = [
    libvorbis
    speex
    flac
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  meta = with lib; {
    homepage = "https://xiph.org/fishsound/";
    description = "Simple programming interface for decoding and encoding audio data using Xiph.org codecs (FLAC, Speex and Vorbis)";
    longDescription = ''
      libfishsound by itself is designed to handle raw codec streams from a lower level layer such as UDP datagrams. When these codecs are used in files, they are commonly encapsulated in Ogg to produce Ogg FLAC, Speex and Ogg Vorbis files.

      libfishsound is a wrapper around the existing codec libraries and provides a consistent, higher-level programming interface. It has been designed for use in a wide variety of applications; it has no direct dependencies on Ogg encapsulation, though it is most commonly used in conjunction with liboggz to decode or encode FLAC, Speex or Vorbis audio tracks in Ogg files, including Ogg Theora and Annodex.

      FishSound has been developed and tested on GNU/Linux, Darwin/MacOSX and Win32. It probably also works on other Unix-like systems via GNU autoconf. For Win32: nmake Makefiles, Visual Studio .NET 2003 solution files and Visual C++ 6.0 workspace files are all provided in the source distribution.
    '';
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
