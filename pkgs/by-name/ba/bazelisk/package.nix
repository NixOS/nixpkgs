{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
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
    "-X github.com/bazelbuild/bazelisk/core.BazeliskVersion=v${finalAttrs.version}"
  ];

  passthru.tests = {
    inherit (nixosTests) bazelisk;
  };

  meta = {
    description = "User-friendly launcher for Bazel";
    mainProgram = "bazelisk";
    longDescription = ''
      A user-friendly launcher for Bazel that automatically downloads and
      runs the correct Bazel version for a given project.

      On NixOS, enable the `programs.bazelisk` module to set up envfs and
      a system bazelrc with the correct tool paths.
    '';
    homepage = "https://github.com/bazelbuild/bazelisk";
    changelog = "https://github.com/bazelbuild/bazelisk/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ elasticdog ];
  };
})
