{ stdenv, fetchurl, libX11, xproto }:

stdenv.mkDerivation rec {
  name = "stalonetray-${version}";
  version = "0.8.1";

  src = fetchurl {
    url = "mirror://sourceforge/stalonetray/${name}.tar.bz2";
    sha256 = "1wp8pnlv34w7xizj1vivnc3fkwqq4qgb9dbrsg15598iw85gi8ll";
  };

  buildInputs = [ libX11 xproto ];

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "Stand alone tray";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };

  passthru = {
    updateInfo = {
      downloadPage = "http://sourceforge.net/projects/stalonetray/files/";
    };
  };
}
