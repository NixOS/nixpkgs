{ stdenv, fetchurl, pkgconfig
, buildsystem
}:

stdenv.mkDerivation rec {

  name = "netsurf-${libname}-${version}";
  libname = "libnspsl";
  version = "0.1.5";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "0siq8zjfxv75i9fw6q5hkaijpdm1w3zskd5qk6vsvz8cqan4vifd";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    buildsystem
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = with stdenv.lib; {
    homepage = "http://www.netsurf-browser.org/";
    description = "NetSurf Public Suffix List - Handling library";
    license = licenses.mit;
    maintainers = [ maintainers.samueldr ];
    platforms = platforms.linux;
  };
}
