{ stdenv, fetchurl, pidgin, intltool, libxml2, nss, nspr }:

let version = "1.23.3"; in

stdenv.mkDerivation {
  name = "pidgin-sipe-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/sipe/pidgin-sipe-${version}.tar.gz";
    sha256 = "0aaiblnagncb0lhdwb8qbps6hxxmyfjg7sdi15lrkl98i3fahg4n";
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
