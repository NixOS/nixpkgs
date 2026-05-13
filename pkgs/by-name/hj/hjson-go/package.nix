{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "hjson-go";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "hjson";
    repo = "hjson-go";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Qg/sy0fHHadQMU1wToz/Nm6tiIe/tm1D1knmbh9zYr0=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Utility to convert JSON to and from HJSON";
    homepage = "https://hjson.github.io/";
    changelog = "https://github.com/hjson/hjson-go/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "hjson-cli";
  };
})
