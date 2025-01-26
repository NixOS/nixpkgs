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
    repo = pname;
    rev = "v${version}";
    sha256 = "0gsdksrzlwpba14a43ayyy41l1hxpw4ayjpvqyd4ycakddlkvgzb";
  };

  vendorHash = null;

  meta = with lib; {
    description = "HTTP load generator, ApacheBench (ab) replacement";
    homepage = "https://github.com/rakyll/hey";
    license = licenses.asl20;
    maintainers = with maintainers; [ Br1ght0ne ];
    mainProgram = "hey";
  };
}
