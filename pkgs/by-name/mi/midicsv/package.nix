{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "midicsv";
  version = "1.1";

  src = fetchurl {
    url = "https://www.fourmilab.ch/webtools/midicsv/midicsv-${version}.tar.gz";
    sha256 = "1vvhk2nf9ilfw0wchmxy8l13hbw9cnpz079nsx5srsy4nnd78nkw";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace /usr/local $out \
      --replace gcc "${stdenv.cc.targetPrefix}cc"
  '';

  meta = with lib; {
    description = "Losslessly translate MIDI to CSV and back";
    homepage = "https://www.fourmilab.ch/webtools/midicsv/";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.all;
  };
}
