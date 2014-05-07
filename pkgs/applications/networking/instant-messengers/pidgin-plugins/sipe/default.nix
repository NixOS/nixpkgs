{ stdenv, fetchurl, pidgin, intltool, libxml2 }:

let version = "1.18.1"; in

stdenv.mkDerivation {
  name = "pidgin-sipe-${version}";
  
  src = fetchurl {
    url = "mirror://sourceforge/sipe/pidgin-sipe-${version}.tar.gz";
    sha256 = "18ch7jpi7ki7xlpahi88xrnmnhc6dcq4hafm0z6d5nfjfp8ldal5";
  };

  meta = {
    description = "SIPE plugin for Pidgin IM";
    homepage = http://sipe.sourceforge.net/;
    license = "GPLv2";
  };

  postInstall = "find $out -ls; ln -s \$out/lib/purple-2 \$out/share/pidgin-sipe";

  buildInputs = [pidgin intltool libxml2];
}
