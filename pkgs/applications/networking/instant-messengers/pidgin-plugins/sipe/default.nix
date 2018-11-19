{ stdenv, fetchurl, pidgin, intltool, libxml2, nss, nspr }:

let version = "1.24.0"; in

stdenv.mkDerivation {
  name = "pidgin-sipe-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/sipe/pidgin-sipe-${version}.tar.gz";
    sha256 = "04cxprz6dbcsc4n2jg72mr1r9630nhrywn0zim9kwvbgps3wdd9c";
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
