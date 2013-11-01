{ stdenv, fetchurl, pidgin, intltool, libxml2 }:

let version = "1.12.0"; in

stdenv.mkDerivation {
  name = "pidgin-sipe-${version}";
  
  src = fetchurl {
    url = "mirror://sourceforge/sipe/pidgin-sipe-${version}.tar.gz";
    sha256 = "12ki6n360v2ja961fzw4mwpgb8jdp9k21y5mbiab151867c862r6";
  };

  meta = {
    description = "SIPE plugin for Pidgin IM";
    homepage = http://sipe.sourceforge.net/;
    license = "GPLv2";
  };

  postInstall = "find $out -ls; ln -s \$out/lib/purple-2 \$out/share/pidgin-sipe";

  buildInputs = [pidgin intltool libxml2];
}
