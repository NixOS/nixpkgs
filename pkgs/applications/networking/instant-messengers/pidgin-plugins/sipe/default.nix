{ stdenv, fetchurl, pidgin, intltool, libxml2, nss, nspr }:

let version = "1.22.0"; in

stdenv.mkDerivation {
  name = "pidgin-sipe-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/sipe/pidgin-sipe-${version}.tar.gz";
    sha256 = "1aeb348e2ba79b82b1fd102555f86cdc42eaa6f9e761b771d74c4f9c9cf15fc3";
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
