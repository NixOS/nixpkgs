{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, gtk3
, gtkmm3
, curl
, poco
, gumbo # litehtml dependency
}:

stdenv.mkDerivation {
  pname = "litebrowser";
  version = "unstable-2022-10-31";

  src = fetchFromGitHub {
    owner = "litehtml";
    repo = "litebrowser-linux";
    rev = "4654f8fb2d5e2deba7ac6223b6639341bd3b7eba";
    hash = "sha256-SvW1AOxLBLKqa+/2u2Zn+/t33ZzQHmqlcLRl6z0rK9U=";
    fetchSubmodules = true; # litehtml submodule
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    gtk3
    gtkmm3
    curl
    poco
    gumbo
  ];

  cmakeFlags = [
    "-DEXTERNAL_GUMBO=ON"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 litebrowser $out/bin/litebrowser
    runHook postInstall
  '';

  meta = with lib; {
    description = "A simple browser based on the litehtml engine";
    homepage = "https://github.com/litehtml/litebrowser-linux";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fgaz ];
  };
}
