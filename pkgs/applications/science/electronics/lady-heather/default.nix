{ lib
, fetchurl
, stdenv
, unzip
, xorg
}:

stdenv.mkDerivation rec {
  pname = "lady-heather";
  version = "5.0";

  src = fetchurl {
    url = "http://www.ke5fx.com/heather/heatherx11.zip";
    sha256 = "1qx2gdh87nqn49xlhz4dbyq5anmgzqwp0w47pfics60v9bp8sr57";
  };

  nativeBuildInputs = [
    unzip
  ];

  buildInputs = [
    xorg.libX11
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp heather $out/bin
    cp heather.xpm $out/bin
    cp heather.xbm $out/bin
    cp *.wav $out/bin
    cp heather.cal $out/bin
  '';

  meta = with lib; {
    description = "This program monitors and controls the operation of various GPS-disciplined frequency standards.";
    homepage = "http://www.ke5fx.com/heather/readme.htm";
    license = licenses.mit;
    maintainers = with maintainers; [ matthuszagh ];
    platforms = platforms.linux;
  };
}
