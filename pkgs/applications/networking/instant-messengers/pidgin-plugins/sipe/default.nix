{ stdenv, fetchurl, pidgin, intltool, libxml2, gmime, nss }:

stdenv.mkDerivation rec {
  pname = "pidgin-sipe";
  version = "1.24.0";

  src = fetchurl {
    url = "mirror://sourceforge/sipe/${pname}-${version}.tar.gz";
    sha256 = "04cxprz6dbcsc4n2jg72mr1r9630nhrywn0zim9kwvbgps3wdd9c";
  };

  nativeBuildInputs = [ intltool ];
  buildInputs = [ pidgin gmime libxml2 nss ];
  enableParallelBuilding = true;

  postInstall = "find $out -ls; ln -s \$out/lib/purple-2 \$out/share/pidgin-sipe";

  meta = with stdenv.lib; {
    description = "SIPE plugin for Pidgin IM";
    homepage = "http://sipe.sourceforge.net/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
