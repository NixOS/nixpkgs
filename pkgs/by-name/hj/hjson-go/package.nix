{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "hjson-go";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "hjson";
    repo = "hjson-go";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tQ4KvDS3f/EbCoONUWJpGqLOC9pMm1HO7eZXZ7xpVB8=";
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
