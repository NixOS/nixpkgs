{ lib, stdenv, fetchurl, pkg-config, buildPackages
, buildsystem
}:

stdenv.mkDerivation rec {
  pname = "netsurf-${libname}";
  libname = "libnsgif";
  version = "0.2.1";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "sha256-nq6lNM1wtTxar0UxeulXcBaFprSojb407Sb0+q6Hmks=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
    "BUILD_CC=$(CC_FOR_BUILD)"
  ];

  meta = with lib; {
    homepage = "https://www.netsurf-browser.org/projects/${libname}/";
    description = "GIF Decoder for netsurf browser";
    license = licenses.mit;
    maintainers = [ maintainers.vrthra maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
