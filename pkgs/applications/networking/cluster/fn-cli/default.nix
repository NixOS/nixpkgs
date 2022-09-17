{ lib, buildGoModule, fetchFromGitHub, docker }:

buildGoModule rec {
  pname = "fn";
  version = "0.6.20";

  src = fetchFromGitHub {
    owner = "fnproject";
    repo = "cli";
    rev = version;
    sha256 = "sha256-HeyWMzxSga6T2/BRVwrmgb3utjnVTJk3zhhcVfq8/Cc=";
  };

  vendorSha256 = null;

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
