{ stdenv, fetchurl, libX11, xorgproto }:

stdenv.mkDerivation rec {
  name = "stalonetray-${version}";
  version = "0.8.3";

  src = fetchurl {
    url = "mirror://sourceforge/stalonetray/${name}.tar.bz2";
    sha256 = "0k7xnpdb6dvx25d67v0crlr32cdnzykdsi9j889njiididc8lm1n";
  };

  buildInputs = [ libX11 xorgproto ];

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "Stand alone tray";
    homepage = http://stalonetray.sourceforge.net;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ raskin ];
  };

  passthru = {
    updateInfo = {
      downloadPage = "https://sourceforge.net/projects/stalonetray/files/";
    };
  };
}
