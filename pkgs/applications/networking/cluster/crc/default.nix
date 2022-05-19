{ lib
, buildGoModule
, fetchFromGitHub
, testers
, crc
}:

buildGoModule rec {
  pname = "crc";
  version = "2.3.0";
  gitCommit = "502bf1d";

  src = fetchFromGitHub {
    owner = "code-ready";
    repo = "crc";
    rev = "v${version}";
    sha256 = "HDIzCMwzqJj/L2wJf10MWRX9u4TbW+EjzBp2LtUqBLg=";
  };

  vendorSha256 = null;

  buildPhase = ''
    make SHELL=$SHELL COMMIT_SHA=${gitCommit}
  '';

  passthru.tests.version = testers.testVersion {
    package = crc;
    command = "crc version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Manages a local OpenShift 4.x cluster or a Podman VM optimized for testing and development purposes";
    homepage = "https://crc.dev";
    license = licenses.asl20;
    maintainers = with maintainers; [ shikanime ];
    mainProgram = "crc";
  };
}
