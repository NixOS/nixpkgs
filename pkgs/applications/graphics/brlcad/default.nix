{ lib
, stdenv
, fetchFromGitHub
, cmake
, fontconfig
, libX11
, libXi
, freetype
, mesa
}:

stdenv.mkDerivation rec {
  pname = "brlcad";
  version = "7.34.0";

  src = fetchFromGitHub {
    owner = "BRL-CAD";
    repo = pname;
    rev = "refs/tags/rel-${lib.replaceStrings [ "." ] [ "-" ] version}";
    hash = "sha256-Re5gEXlqdPxniaEP13Q0v0O9rt40V5NrxoUpcNBwn7s=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    fontconfig
    libX11
    libXi
    freetype
    mesa
  ];

  cmakeFlags = [
    "-DBRLCAD_ENABLE_STRICT=OFF"
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  meta = with lib; {
    homepage = "https://brlcad.org";
    description = "BRL-CAD is a powerful cross-platform open source combinatorial solid modeling system";
    license = with licenses; [ lgpl21 bsd2 ];
    maintainers = with maintainers; [ GaetanLepage ];
    platforms = platforms.linux;
  };
}
