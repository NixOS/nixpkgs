{ stdenv, fetchurl, pidgin, intltool, libxml2 }:

let version = "1.10.0"; in

stdenv.mkDerivation {
  name = "pidgin-sipe-${version}";
  
  src = fetchurl {
    url = "mirror://sourceforge/sipe/sipe/pidgin-sipe-${version}/pidgin-sipe-${version}.tar.gz";
    sha256 = "11d85qxix1dmwvzs3lx0sycsx1d5sy67r9y78fs7z716py4mg9np";
  };

  patches = [ ./fix-2.7.0.patch ];

  meta = {
    description = "SIPE plugin for Pidgin IM.";
    homepage = http://sipe.sourceforge.net/;
    license = "GPLv2";
  };

  postInstall = "find $out -ls; ln -s \$out/lib/purple-2 \$out/share/pidgin-sipe";

  buildInputs = [pidgin intltool libxml2];
}
