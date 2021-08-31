{ lib, buildGoModule, fetchFromGitHub, docker }:

buildGoModule rec {
  pname = "fn";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "fnproject";
    repo = "cli";
    rev = version;
    sha256 = "sha256-8b1VyukVMTXLAnvYcjXgTdPtMq3YxJgTpxe25Kj+Wpw=";
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
