{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "indigo";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "bluesky-social";
    repo = "indigo";
    tag = "tap-v${finalAttrs.version}";
    hash = "sha256-nDOLIRWTyj/R0h+70+bGi85RVe2OKLNbnSaKyyqc93Q=";
  };

  vendorHash = "sha256-s1S+b+QbptqJ2mxqkvsn7M5VWfLrlwpWgRjg6lq2WVE=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Utilities and source code for Bluesky's atproto services";
    mainProgram = "tap";
    homepage = "https://atproto.com";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ raylas ];
  };
})
