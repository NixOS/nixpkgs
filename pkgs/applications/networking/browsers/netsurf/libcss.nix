{ stdenv, fetchurl, pkgconfig, perl
, buildsystem
, libparserutils
, libwapcaplet
}:

stdenv.mkDerivation rec {
  pname = "netsurf-${libname}";
  libname = "libcss";
  version = "0.9.1";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "sha256-0tzhbpM5Lo1qcglCDUfC1Wo4EXAaDoGnJPxUHGPTxtw=";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    perl
    libparserutils
    libwapcaplet
    buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  NIX_CFLAGS_COMPILE= "-Wno-error=implicit-fallthrough";

  meta = with stdenv.lib; {
    homepage = "https://www.netsurf-browser.org/projects/${libname}/";
    description = "Cascading Style Sheets library for netsurf browser";
    longDescription = ''
      LibCSS is a CSS parser and selection engine. It aims to parse the forward
      compatible CSS grammar. It was developed as part of the NetSurf project
      and is available for use by other software, under a more permissive
      license.
    '';
    license = licenses.mit;
    maintainers = [ maintainers.vrthra maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
