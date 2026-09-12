{
  lib,
  buildGoModule,
  fetchFromGitHub,
  jq,
  oniguruma,
}:

buildGoModule (finalAttrs: {
  pname = "faq";
  # Latest git release (0.0.7) presents vendor issues - using latest commit instead.
  version = "0.0.7-unstable-2022-01-09";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jzelinskie";
    repo = "faq";
    rev = "594bb8e15dc4070300f39c168354784988646231";
    hash = "sha256-IVnvqHjzUdiGwK2treZ/p9TayUZXS1q8sSZITSRkGdM=";
  };
  vendorHash = "sha256-731eINkboZiuPXX/HQ4r/8ogLedKBWx1IV7BZRKwU3A";

  buildInputs = [
    jq
    oniguruma
  ];

  ldflags = [
    "-s"
    "-X github.com/jzelinskie/faq/internal/version.Version=${finalAttrs.version}"
  ];

  tags = [
    "netgo"
  ];

  subPackages = [
    "cmd/faq"
  ];

  doCheck = true;

  meta = {
    description = "Intended to be a more flexible jq, supporting additional formats";
    mainProgram = "faq";
    homepage = "https://github.com/jzelinskie/faq";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ quentin-m ];
  };
})
