{lib, stdenv, fetchurl, fetchpatch, libao, libmad, libid3tag, zlib, alsa-lib
# Specify default libao output plugin to use (e.g. "alsa", "pulse" …).
# If null, it will use the libao system default.
, defaultAudio ? null
}:

stdenv.mkDerivation rec {
  pname = "mpg321";
  version = "0.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/mpg321/${version}/mpg321_${version}.orig.tar.gz";
    sha256 = "0ki8mh76bbmdh77qsiw682dvi8y468yhbdabqwg05igmwc1wqvq5";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2018-7263.patch";
      url = "https://sources.debian.org/data/main/m/mpg321/0.3.2-3/debian/patches/handle_illegal_bitrate_value.patch";
      sha256 = "15simp5fjvm9b024ryfh441rkh2d5bcrizqkzlrh07n9sm7fkw6x";
    })
    # Apple defines semun already. Skip redefining it to fix build errors.
    (fetchpatch {
      url = "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/mpg321/0.3.2.patch";
      sha256 = "sha256-qFYpKpE9PZSzOJrnsQINZi6FvUVX0anRyOvlF5eOYqE=";
    })
  ];

  hardeningDisable = [ "format" ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: volume.o:/build/mpg321-0.3.2-orig/mpg321.h:119: multiple definition of
  #     `loop_remaining'; mpg321.o:/build/mpg321-0.3.2-orig/mpg321.h:119: first defined here
  NIX_CFLAGS_COMPILE = "-fcommon";

  configureFlags =
    [ ("--enable-alsa=" + (if stdenv.isLinux then "yes" else "no")) ]
    ++ (lib.optional (defaultAudio != null)
         "--with-default-audio=${defaultAudio}");

  buildInputs = [libao libid3tag libmad zlib]
    ++ lib.optional stdenv.isLinux alsa-lib;

  installTargets = [ "install" "install-man" ];

  meta = with lib; {
    description = "Command-line MP3 player";
    homepage = "http://mpg321.sourceforge.net/";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
