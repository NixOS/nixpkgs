{ stdenv
, fetchurl
, autoPatchelfHook
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  version = "209";
  pname = "write-${version}";

  src = fetchurl {
    url = "www.styluslabs.com/write/write209.tar.gz";
    sha256 = "1p6glp4vdpwl8hmhypayc4cvs3j9jfmjfhhrgqm2xkgl5bfbv2qd";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp Write $out/bin/
  '';

  nativeBuildInputs = [
    wrapQtAppsHook
    autoPatchelfHook
  ];

  meta = with stdenv.lib; {
    homepage = "www.styluslabs.com";
    description = "Write is a word processor for handwriting";
    license = licenses.unfree;
    maintainers = with maintainers; [
      olynch
    ];
    platforms = platforms.linux;
  };
}
