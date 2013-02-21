{ stdenv, fetchurl, alsaLib, jackaudio, pkgconfig, pulseaudio, xlibs }:

stdenv.mkDerivation  rec {
  name = "bristol-${version}";
  version = "0.60.10";

  src = fetchurl {
    url = "mirror://sourceforge/bristol/${name}.tar.gz";
    sha256 = "070rn5zdx6vrqmq7w1rrpxig3bxlylbsw82nlmkjnhjrgm6yx753";
  };

  buildInputs = [
    alsaLib jackaudio pkgconfig pulseaudio xlibs.libX11 xlibs.libXext
    xlibs.xproto
  ];

  preInstall = ''
    sed -e "s@\`which bristol\`@$out/bin/bristol@g" -i bin/startBristol
    sed -e "s@\`which brighton\`@$out/bin/brighton@g" -i bin/startBristol
  '';

  meta = with stdenv.lib; {
    description = "A range of synthesiser, electric piano and organ emulations";
    homepage = http://bristol.sourceforge.net;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}