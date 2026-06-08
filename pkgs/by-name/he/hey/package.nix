{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "hey";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "rakyll";
    repo = "hey";
    rev = "v${finalAttrs.version}";
    sha256 = "0gsdksrzlwpba14a43ayyy41l1hxpw4ayjpvqyd4ycakddlkvgzb";
  };

  vendorHash = null;

  meta = {
    description = "HTTP load generator, ApacheBench (ab) replacement";
    homepage = "https://github.com/rakyll/hey";
    license = lib.licenses.asl20;
    mainProgram = "hey";
  };
})
