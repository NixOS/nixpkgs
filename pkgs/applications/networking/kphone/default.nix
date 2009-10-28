args: with args;

stdenv.mkDerivation {
  name = "kphone-1.2";

  src = fetchurl {
    url = mirror://sourceforge/kphone/files/KPhone%20SI/KPhoneSIv1.2/kphoneSI_1.2.tar.gz;
    sha256 = "1q309n2gsdsa8d7ff2zwnyc69ngpnnj143dys90dnlmzr9ckhhg3";
  };

  buildInputs =
    [ autoconf automake libtool qt pkgconfig openssl libpng alsaLib
      libX11 libXext libXt libICE libSM libX11
    ];
    
  preConfigure = "autoconf";

  meta = {
    description = "KPhone is a SIP UA for Linux";
    homepage = http://sourceforge.net/projects/kphone/;
    license = "GPL";
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
