{ lib, buildGoModule, fetchFromGitHub, docker }:

buildGoModule rec {
  pname = "fn";
  version = "0.6.34";

  src = fetchFromGitHub {
    owner = "fnproject";
    repo = "cli";
    rev = version;
    hash = "sha256-rbZySF7DrBN37YIetFXZE/aPSRex5cQnV8FZ0KDQ71k=";
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
