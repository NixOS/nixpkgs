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

<<<<<<< HEAD
  meta = {
    description = "HTTP load generator, ApacheBench (ab) replacement";
    homepage = "https://github.com/rakyll/hey";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "HTTP load generator, ApacheBench (ab) replacement";
    homepage = "https://github.com/rakyll/hey";
    license = licenses.asl20;
    maintainers = with maintainers; [ Br1ght0ne ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "hey";
  };
}
