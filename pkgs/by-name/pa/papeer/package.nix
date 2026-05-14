{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "papeer";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "lapwat";
    repo = "papeer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZfJ8ABdp5G4j/FQCJwDz0O+CCbV2rn8e7Rhwj699h+I=";
  };

  vendorHash = "sha256-PlpulU0nlZA3Vmiqn/rqAS73yJniTECje7uc7kjE6aw=";

  doCheck = false; # uses network

  meta = {
    description = "Convert websites into ebooks and markdown";
    mainProgram = "papeer";
    homepage = "https://papeer.tech/";
    license = lib.licenses.gpl3Plus;
  };
})
