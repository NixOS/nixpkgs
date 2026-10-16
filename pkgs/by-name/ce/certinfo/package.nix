{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "certinfo";
  version = "1.0.40";

  src = fetchFromGitHub {
    owner = "pete911";
    repo = "certinfo";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-2Feb2+7UJ+39waO9rFyT3ZDlEdS5s3uLuxUiDh4iuJE=";
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
