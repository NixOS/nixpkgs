{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "certinfo";
  version = "1.0.41";

  src = fetchFromGitHub {
    owner = "pete911";
    repo = "certinfo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ieqR/LkjQzKxycLTCIP5mGCrtDZcbqlcXmSzaIVp3zA=";
  };

  ldflags = [
    "-X main.Version=${finalAttrs.version}"
  ];

  vendorHash = null;

  meta = {
    description = "Print x509 certificate info";
    mainProgram = "certinfo";
    homepage = "https://github.com/pete911/certinfo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jakuzure ];
  };
})
