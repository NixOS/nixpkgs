{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  version = "2.11.10";
  pname = "coinutils";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "CoinUtils";
    rev = "releases/${version}";
    hash = "sha256-Rbm45HRbRKQ6Cdup+gvKJ1xkK1HKG3irR5AIjhLer7g=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/coin-or/CoinUtils/commit/1700ed92c2bc1562aabe65dee3b4885bd5c87fb9.patch";
      stripLen = 1;
      extraPrefix = "CoinUtils/";
      hash = "sha256-8S6XteZvoJlL+5MWiOrW7HXsdcnzpuEFTyzX9qg7OUY=";
    })
  ];

  doCheck = true;

  meta = with lib; {
    license = licenses.epl20;
    homepage = "https://github.com/coin-or/CoinUtils";
    description = "Collection of classes and helper functions that are generally useful to multiple COIN-OR projects";
    maintainers = with maintainers; [ tmarkus ];
  };
}
