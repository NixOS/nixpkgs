{ lib, stdenv, buildGoModule, fetchFromGitHub, docker }:

buildGoModule rec {
  pname = "fn";
  version = "0.6.24";

  src = fetchFromGitHub {
    owner = "fnproject";
    repo = "cli";
    rev = version;
    hash = "sha256-em9Bfrk7jJdmg3N+zH0VTpCdKPEOBK8vc297V5vmKzM=";
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
    homepage = "https://fnproject.io";
    license = licenses.asl20;
    maintainers = [ maintainers.c4605 ];
  };
}
