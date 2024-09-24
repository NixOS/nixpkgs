{ lib
, stdenv
, fetchurl
, cmake
, unzip
, gmp
, scalp
}:

stdenv.mkDerivation rec {
  pname = "pagsuite";
  version = "1.80";

  src = fetchurl {
    url = "https://gitlab.com/kumm/pagsuite/-/raw/master/releases/pagsuite_${lib.replaceStrings ["."] ["_"] version}.zip";
    hash = "sha256-TYd+dleVPWEWU9Cb3XExd7ixJZyiUAp9QLtorYJSIbQ=";
  };

  sourceRoot = "pagsuite_${lib.replaceStrings ["."] ["_"] version}";

  nativeBuildInputs = [
    cmake
    unzip
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
