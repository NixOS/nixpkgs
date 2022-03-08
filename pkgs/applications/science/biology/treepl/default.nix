{ lib, stdenv, fetchFromGitHub, nlopt, adolc }:

stdenv.mkDerivation rec {
  pname = "treepl";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "blackrim";
    repo = "treePL";
    sha256 = "0pcqg6y2dqrkflmpsrggaaf6xf0x6qa5d4rrzjkk1vp42d7k2s4y";
    rev = "${version}";
  };

  buildInputs = [ nlopt adolc ];

  makeFlags = [ "prefix=$(out)/bin/" ];

  sourceRoot = "source/src";

  preInstall = "mkdir -p $out/bin";

  meta = with lib; {
    description = "Phylogenetic penalized likelihood program";
    homepage = "https://github.com/blackrim/treePL/wiki";
    maintainers = [ maintainers.bzizou ];
  };
}

