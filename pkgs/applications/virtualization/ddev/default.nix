{ lib
, bash
, curl
, docker
, docker-compose
, fetchFromGitHub
, git
, go
, pkgs
, stdenv
, testers
, ddev }:


let
  pname = "ddev";
  version = "1.21.6";
in

stdenv.mkDerivation {
  name = pname;
  version = version;
  src = fetchFromGitHub {
    owner = "ddev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Wjg0Yxo/ulY6R6hhUMFvNZUSwpXENmAHU7GPbgdw7tw=";
  };
  buildInputs = [ bash curl git go ];
  makeFLags = [ "SHELL=${bash}/bin/bash" ];
  buildFlags = ["build"];

  passthru.tests.version = testers.testVersion {
    package = ddev;
    command = "HOME=$(mktemp -d) ddev --version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Docker-based local PHP + Node.js web development environments";
    homepage = "https://ddev.readthedocs.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ jgonyea ];
  };
}
