{ lib, stdenv, fetchurl, perl
, buildsystem
}:

stdenv.mkDerivation rec {
  pname = "netsurf-${libname}";
  libname = "libparserutils";
  version = "0.2.4";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "sha256-MiuuYbMMzt4+MFv26uJBSSBkl3W8X/HRtogBKjxJR9g=";
  };

  buildInputs = [ perl buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = with lib; {
    homepage = "https://www.netsurf-browser.org/projects/${libname}/";
    description = "Parser building library for netsurf browser";
    license = licenses.mit;
    maintainers = [ maintainers.vrthra maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
