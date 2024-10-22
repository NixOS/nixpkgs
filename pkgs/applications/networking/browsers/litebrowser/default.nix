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
  version = "unstable-2024-02-25";

  src = fetchFromGitHub {
    owner = "litehtml";
    repo = "litebrowser-linux";
    rev = "8130cf50af90e07d201d43b934b5a57f7ed4e68d";
    hash = "sha256-L/pd4VypDfjLKfh+HLpc4um+POWGzGa4OOttudwJxyk=";
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
    broken = stdenv.cc.isClang;  # https://github.com/litehtml/litebrowser-linux/issues/19
    description = "Simple browser based on the litehtml engine";
    mainProgram = "litebrowser";
    homepage = "https://github.com/litehtml/litebrowser-linux";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fgaz ];
  };
}
