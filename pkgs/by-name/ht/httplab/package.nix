{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "httplab";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "qustavo";
    repo = "httplab";
    rev = "v${version}";
    hash = "sha256-UL1i8JpgofXUB+jtW2EtSR1pM/Fdqnbg2EXPJAjc0H0=";
  };

  vendorHash = "sha256-vL3a9eO5G0WqnqcIjA9D2XM7iQ87JH0q+an2nLcG28A=";

  ldflags = [
    "-s"
    "-w"
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/qustavo/httplab";
    description = "Interactive WebServer";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    homepage = "https://github.com/qustavo/httplab";
    description = "Interactive WebServer";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "httplab";
  };
}
