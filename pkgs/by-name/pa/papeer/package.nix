{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "papeer";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "lapwat";
    repo = "papeer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ICiw45pRKlsO2nPlyf/YkFXBzgclwm3cSc5d9BzyT6U=";
  };

  vendorHash = "sha256-xlZWA87dRWU+dnmf4RqqkrIXVyI2Sg/odwPe7GQbgn8=";

  doCheck = false; # uses network

  meta = {
    description = "Convert websites into ebooks and markdown";
    mainProgram = "papeer";
    homepage = "https://papeer.tech/";
    license = lib.licenses.gpl3Plus;
  };
})
