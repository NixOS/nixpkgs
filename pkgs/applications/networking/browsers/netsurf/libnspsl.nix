{ lib, stdenv, fetchurl, pkg-config
, buildsystem
}:

stdenv.mkDerivation rec {
  pname = "netsurf-${libname}";
  libname = "libnspsl";
  version = "0.1.6";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "sha256-08WCBct40xC/gcpVNHotCYcZzsrHBGvDZ5g7E4tFAgs=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = with lib; {
    homepage = "https://www.netsurf-browser.org/";
    description = "NetSurf Public Suffix List - Handling library";
    license = licenses.mit;
    maintainers =  [ maintainers.samueldr maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
