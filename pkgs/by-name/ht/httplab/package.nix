{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "httplab";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "qustavo";
    repo = "httplab";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UL1i8JpgofXUB+jtW2EtSR1pM/Fdqnbg2EXPJAjc0H0=";
  };

  vendorHash = "sha256-vL3a9eO5G0WqnqcIjA9D2XM7iQ87JH0q+an2nLcG28A=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    homepage = "https://github.com/qustavo/httplab";
    description = "Interactive WebServer";
    license = lib.licenses.mit;
    mainProgram = "httplab";
  };
})
