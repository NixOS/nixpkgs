{
  lib,
  stdenv,
  fetchurl,
  libosip,
  openssl,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "libexosip2";
  version = "5.3.0";

  src = fetchurl {
    url = "mirror://savannah/exosip/${pname}-${version}.tar.gz";
    sha256 = "sha256-W3gjmGQx6lztyfCV1pZKzpZvCTsq59CwhAR4i/zrycI=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libosip
    openssl
  ];

  meta = with lib; {
    license = licenses.gpl2Plus;
    description = "Library that hides the complexity of using the SIP protocol";
    platforms = platforms.linux;
  };
}
