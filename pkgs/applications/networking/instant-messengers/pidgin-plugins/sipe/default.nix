{ stdenv, fetchurl, pidgin, intltool, libxml2, gmime, nss }:

stdenv.mkDerivation rec {
  pname = "pidgin-sipe";
  version = "1.25.0";

  src = fetchurl {
    url = "mirror://sourceforge/sipe/${pname}-${version}.tar.gz";
    sha256 = "0262sz00iqxylx0xfyr48xikhiqzr8pg7b4b7vwj5iv4qxpxv939";
  };

  nativeBuildInputs = [ intltool ];
  buildInputs = [ pidgin gmime libxml2 nss ];
  enableParallelBuilding = true;

  postInstall = "ln -s \$out/lib/purple-2 \$out/share/pidgin-sipe";

  meta = with stdenv.lib; {
    description = "SIPE plugin for Pidgin IM";
    homepage = "http://sipe.sourceforge.net/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
