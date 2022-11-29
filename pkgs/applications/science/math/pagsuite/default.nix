{ lib
, stdenv
, fetchzip
, cmake
, gmp
, scalp
}:

stdenv.mkDerivation rec {
  pname = "pagsuite";
  version = "1.80";

  src = fetchzip {
    url = "https://gitlab.com/kumm/pagsuite/-/raw/master/releases/pagsuite_${lib.replaceStrings ["."] ["_"] version}.zip";
    sha256 = "sha256-JuRuDPhKKBGz8jUBkZcZW5s2berOewjsPNR/n7kuofY=";
    stripRoot = false;
    postFetch = ''
      mv $out/pagsuite*/* $out
    '';
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    gmp
    scalp
  ];

  meta = with lib; {
    description = "Optimization tools for the (P)MCM problem";
    homepage = "https://gitlab.com/kumm/pagsuite";
    maintainers = with maintainers; [ wegank ];
    license = licenses.unfree;
  };
}
