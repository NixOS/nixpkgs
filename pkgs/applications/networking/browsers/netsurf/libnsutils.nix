{ stdenv, fetchurl, pkgconfig
, buildsystem
}:

stdenv.mkDerivation rec {
  pname = "netsurf-${libname}";
  libname = "libnsutils";
  version = "0.1.0";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "sha256-eQxlFjRKvoL2KJ1lY5LpzOvkdbIMx+Hi2EMBE4X3rvA=";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = with stdenv.lib; {
    homepage = "https://www.netsurf-browser.org/projects/${libname}/";
    description = "Generalised utility library for netsurf browser";
    license = licenses.mit;
    maintainers = [ maintainers.vrthra maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
