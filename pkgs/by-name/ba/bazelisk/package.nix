{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "bazelisk";
  version = "1.28.1";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazelisk";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-iKU8B8yOT8cPvZhuor8ZVRsHQDoXq1ja1mr60XqHoEs=";
  };

  vendorHash = "sha256-PWqKq/2DFopeiecUL0iWnut8Kd/52U32sNSVGj3Ae5g=";

  ldflags = [
    "-s"
    "-w"
    "-X main.BazeliskVersion=${finalAttrs.version}"
  ];

  meta = {
    description = "User-friendly launcher for Bazel";
    mainProgram = "bazelisk";
    longDescription = ''
      BEWARE: This package does not work on NixOS.
    '';
    homepage = "https://github.com/bazelbuild/bazelisk";
    changelog = "https://github.com/bazelbuild/bazelisk/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ elasticdog ];
  };
})
