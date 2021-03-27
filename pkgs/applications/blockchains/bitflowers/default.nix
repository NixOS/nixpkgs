{ lib
, stdenv
, qmake
, fetchFromGitHub
, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "bitflowers";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "Crypto-city";
    repo = "bitFlowers";
    rev = "v${version}";
    sha256 = "nL8fxb1auboXVQdpy4lkZ09GiORmj56FqzGpr6VK9jI=";
  };

  qmakeFlags = [ "bitFlowers-qt.pro" ];

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  # buildInputs = [
  # ];
  meta = with lib; {
    homepage = "https://bit-flowers.com/";
    longDescription = ''
      bitFlowers; a Crypto-city crypto currency project, which aims to provide eGifting 
      functionality directly in the core of the bitFlowers wallet. 
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 ];
  };
}
