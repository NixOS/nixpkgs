{
  lib,
  buildGoModule,
  fetchFromGitHub,
  docker,
}:

buildGoModule rec {
  pname = "fn";
  version = "0.6.45";

  src = fetchFromGitHub {
    owner = "fnproject";
    repo = "cli";
    rev = version;
    hash = "sha256-iW59tennUgDfYhMGbzdLizo3u+bROWOGbeAl319lsHk=";
  };

  vendorHash = null;

  subPackages = [ "." ];

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
