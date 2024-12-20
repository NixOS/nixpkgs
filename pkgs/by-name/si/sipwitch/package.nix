{
  fetchurl,
  lib,
  stdenv,
  pkg-config,
  ucommon,
  libosip,
  libexosip,
  gnutls,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "sipwitch";
  version = "1.9.15";

  src = fetchurl {
    url = "mirror://gnu/sipwitch/sipwitch-${version}.tar.gz";
    sha256 = "2a7aa86a653f6810b3cd9cce6c37b3f70e937e7d14b09fd5c2a70d70588a9482";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    ucommon
    libosip
    libexosip
    gnutls
    zlib
  ];

  preConfigure = ''
    export configureFlags="--sysconfdir=$out/etc"
  '';

  doCheck = true;

  meta = {
    description = "Secure peer-to-peer VoIP server that uses the SIP protocol";
    homepage = "https://www.gnu.org/software/sipwitch/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = with lib.platforms; linux;
    broken = true; # Require libexosip2 < 5.0.0 which is vulnerable to CVE-2014-10375.
  };
}
