{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  file,
  protobufc,
}:

stdenv.mkDerivation rec {
  pname = "libivykis";

  version = "0.43.2";

  src = fetchurl {
    url = "mirror://sourceforge/libivykis/${version}/ivykis-${version}.tar.gz";
    sha256 = "sha256-k+PpsjdpVDfNY9SqSKjZ39izm8KKGSpXcNETxP6Qme8=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    file
    protobufc
  ];

  meta = with lib; {
    homepage = "https://libivykis.sourceforge.net/";
    description = ''
      A thin wrapper over various OS'es implementation of I/O readiness
      notification facilities
    '';
    license = licenses.zlib;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
