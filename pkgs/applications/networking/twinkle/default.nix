{ stdenv, fetchurl, pkgconfig, commoncpp2, ccrtp, openssl, boost
, libsndfile, libxml2, libjpeg, readline, qt3, perl, file
, alsaLib, speex, libzrtpcpp, xorg }:
        
stdenv.mkDerivation {
  name = "twinkle-1.4.2";

  src = fetchurl {
    url = http://www.xs4all.nl/~mfnboer/twinkle/download/twinkle-1.4.2.tar.gz;
    sha256 = "19c9gqam78srsgv0463g7lfnv4mn5lvbxx3zl87bnm0vmk3qcxl0";
  };

  configureFlags = "--with-extra-includes=${libjpeg}/include";

  buildInputs =
    [ pkgconfig commoncpp2 ccrtp openssl boost libsndfile
      libxml2 libjpeg readline qt3 perl file
      # optional ? :
      alsaLib
      speex libzrtpcpp xorg.libX11 xorg.libXaw xorg.libICE xorg.libXext
    ];

  meta = { 
    homepage = http://www.xs4all.nl/~mfnboer/twinkle/index.html;
    license = "GPL";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
