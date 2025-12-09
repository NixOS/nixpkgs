{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "hey";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "rakyll";
    repo = "hey";
    rev = "v${version}";
    sha256 = "0gsdksrzlwpba14a43ayyy41l1hxpw4ayjpvqyd4ycakddlkvgzb";
  };

  vendorHash = null;

  meta = with lib; {
    description = "HTTP load generator, ApacheBench (ab) replacement";
    homepage = "https://github.com/rakyll/hey";
    license = licenses.asl20;
    mainProgram = "hey";
  };
}
