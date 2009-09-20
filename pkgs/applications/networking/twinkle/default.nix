args: with args;
stdenv.mkDerivation {
  name = "twinkle-1.4.2";

  src = fetchurl {
    url = http://www.xs4all.nl/~mfnboer/twinkle/download/twinkle-1.4.2.tar.gz;
    sha256 = "19c9gqam78srsgv0463g7lfnv4mn5lvbxx3zl87bnm0vmk3qcxl0";
  };

  configureFlags = "--with-extra-includes=${libjpeg}/include";

  buildInputs = [pkgconfig commoncpp2 ccrtp openssl boost libsndfile
    libxml2 libjpeg readline qt libjpeg perl file
    # optional ? :
    alsaLib
    speex libzrtpcpp libX11 libXaw libICE libXext
    ];


  meta = { 
    description = "softphone for your voice over IP";
    homepage = http://www.xs4all.nl/~mfnboer/twinkle/index.html;
    license = "GPL";
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
