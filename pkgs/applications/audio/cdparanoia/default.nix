{ stdenv, fetchurl, IOKit, Carbon }:

stdenv.mkDerivation rec {
  name = "cdparanoia-III-10.2";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/cdparanoia/${name}.src.tgz";
    sha256 = "1pv4zrajm46za0f6lv162iqffih57a8ly4pc69f7y0gfyigb8p80";
  };

  preConfigure = "unset CC";

  patches = stdenv.lib.optionals stdenv.isDarwin [
    (fetchurl {
      url = "https://trac.macports.org/export/70964/trunk/dports/audio/cdparanoia/files/osx_interface.patch";
      sha1 = "c86e573f51e6d58d5f349b22802a7a7eeece9fcd";
    })
    (fetchurl {
      url = "https://trac.macports.org/export/70964/trunk/dports/audio/cdparanoia/files/patch-paranoia_paranoia.c.10.4.diff";
      sha1 = "d7dc121374df3b82e82adf544df7bf1eec377bdb";
    })
  ];

  buildInputs = stdenv.lib.optional stdenv.isDarwin [
    Carbon
    IOKit
  ];

  meta = {
    homepage = http://xiph.org/paranoia;
    description = "A tool and library for reading digital audio from CDs";
  };
}
