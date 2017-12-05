{ stdenv, fetchurl, pidgin, intltool, libxml2, nss, nspr }:

let version = "1.22.1"; in

stdenv.mkDerivation {
  name = "pidgin-sipe-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/sipe/pidgin-sipe-${version}.tar.gz";
    sha256 = "f6b7b7475e349c0214eb02814b808b04850113a91dd8e8d2c26e7179a3fd1ae8";
  };

  meta = with stdenv.lib; {
    description = "SIPE plugin for Pidgin IM";
    homepage = http://sipe.sourceforge.net/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };

  postInstall = "find $out -ls; ln -s \$out/lib/purple-2 \$out/share/pidgin-sipe";

  buildInputs = [ pidgin intltool libxml2 nss nspr ];

}
