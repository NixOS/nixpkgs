{
  lib,
  fetchFromGitHub,
  buildGoModule,
  enableUnfree ? true,
}:

buildGoModule (finalAttrs: {
  pname = "drone.io${lib.optionalString (!enableUnfree) "-oss"}";
  version = "2.28.2";

  src = fetchFromGitHub {
    owner = "harness";
    repo = "drone";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jKM+jET6dsMe5+QRDKIHA40OOHb/nZmli3owaDB7IvU=";
  };

  vendorHash = "sha256-BHfuQ4bloqvdqHK4HSlzHVd9r0yhGkWqLY0XZazwiZQ=";

  tags = lib.optionals (!enableUnfree) [
    "oss"
    "nolimit"
  ];

  doCheck = false;

  meta = {
    description = "Continuous Integration platform built on container technology";
    mainProgram = "drone-server";
    homepage = "https://github.com/harness/drone";
    maintainers = with lib.maintainers; [
      vdemeester
      techknowlogick
    ];
    license = with lib.licenses; if enableUnfree then unfreeRedistributable else asl20;
  };
})
