{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libmnl,
}:

stdenv.mkDerivation rec {
  pname = "ipset";
  version = "7.23";

  src = fetchurl {
    url = "https://ipset.netfilter.org/${pname}-${version}.tar.bz2";
    sha256 = "sha256-2zpRqevyfHy9ChSCxGxeDtYwwox5b3MofEszndRghuU=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libmnl ];

  configureFlags = [ "--with-kmod=no" ];

  meta = {
    homepage = "https://ipset.netfilter.org/";
    description = "Administration tool for IP sets";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
