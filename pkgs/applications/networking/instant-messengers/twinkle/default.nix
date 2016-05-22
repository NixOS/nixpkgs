{ stdenv, fetchurl, pkgconfig, autoreconfHook, commoncpp2, ccrtp, openssl, boost
, libsndfile, libxml2, libjpeg, readline, qt3, perl, file
, alsaLib, speex, libzrtpcpp, xorg }:

stdenv.mkDerivation rec {
  name = "twinkle-1.4.2";

  src = fetchurl {
    url = "http://www.xs4all.nl/~mfnboer/twinkle/download/${name}.tar.gz";
    sha256 = "19c9gqam78srsgv0463g7lfnv4mn5lvbxx3zl87bnm0vmk3qcxl0";
  };

  patches = [ # all from Debian
    ./newer-libccrtp.diff
    ./libgsm.patch
    ./localetime_r_conflict.diff
    ./boost_regex.patch # modified not to use "-mt" suffix
  ];

  configureFlags = "--with-extra-includes=${libjpeg.dev}/include";

  buildInputs =
    [ pkgconfig autoreconfHook commoncpp2 openssl boost libsndfile
      libxml2 libjpeg readline qt3 perl file ccrtp
      # optional ? :
      alsaLib speex
      libzrtpcpp xorg.libX11 xorg.libXaw xorg.libICE xorg.libXext
    ];

  NIX_CFLAGS_LINK = "-Wl,--as-needed -lboost_regex -lasound -lzrtpcpp -lspeex -lspeexdsp";

  #enableParallelBuilding = true; # fatal error: messageform.h: No such file or directory

  meta = with stdenv.lib; {
    homepage = http://www.twinklephone.com/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.linux;
  };
}
