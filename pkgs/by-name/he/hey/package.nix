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
    hash = "sha256-6789aWtTMU+ax/tKrwi/HQYaiPdeDaJIUOty+rOeTT8=";
  };

  vendorHash = null;

  meta = {
    description = "HTTP load generator, ApacheBench (ab) replacement";
    homepage = "https://github.com/rakyll/hey";
    license = lib.licenses.asl20;
    mainProgram = "hey";
  };
})
