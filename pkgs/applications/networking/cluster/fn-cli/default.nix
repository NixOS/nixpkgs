{ lib, stdenv, buildGoModule, fetchFromGitHub, docker }:

buildGoModule rec {
  pname = "fn";
  version = "0.6.32";

  src = fetchFromGitHub {
    owner = "fnproject";
    repo = "cli";
    rev = version;
    hash = "sha256-mXHDxmjQdfO6uZ1ROcxwtDaPvbv2kFV+qLbejn3Kycs=";
  };

  vendorHash = null;

  subPackages = ["."];

  buildInputs = [
    docker
  ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  postInstall = ''
    mv $out/bin/cli $out/bin/fn
  '';

  meta = with lib; {
    description = "Command-line tool for the fn project";
    mainProgram = "fn";
    homepage = "https://fnproject.io";
    license = licenses.asl20;
    maintainers = [ maintainers.c4605 ];
  };
}
