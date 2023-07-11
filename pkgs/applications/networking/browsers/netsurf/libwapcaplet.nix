{ lib, stdenv, fetchurl
, buildsystem
}:

stdenv.mkDerivation rec {
  pname = "netsurf-${libname}";
  libname = "libwapcaplet";
  version = "0.4.3";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "sha256-myqh3W1mRfjpkrNpf9vYfwwOHaVyH6VO0ptITRMWDFw=";
  };

  buildInputs = [ buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=cast-function-type";

  meta = with lib; {
    homepage = "https://www.netsurf-browser.org/projects/${libname}/";
    description = "String internment library for netsurf browser";
    license = licenses.mit;
    maintainers = [ maintainers.vrthra maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
