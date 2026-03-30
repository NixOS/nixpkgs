{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "panicparse";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "maruel";
    repo = "panicparse";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-EBNOHI04v47sXAWrjHsU4pixP4TPOuHy8S3YmlkiLN4=";
  };

  vendorHash = "sha256-/w/dtt55NVHoJ5AeHsqH/IRe3bJq1YvpasLh8Zn8Ckg=";

  subPackages = [ "." ];

  meta = {
    description = "Crash your app in style (Golang)";
    homepage = "https://github.com/maruel/panicparse";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "panicparse";
  };
})
