{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "bazelisk";
  version = "1.29.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazelisk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NijRYjJyWOqSkfDKOdki3nrc1OIhfooKLhusuiMY/Js=";
  };

  vendorHash = "sha256-oycCqzUAn/lNFjeLjM+PQfYNscaTi5E9D7Pnv8jrO8M=";

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
    changelog = "https://github.com/bazelbuild/bazelisk/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      hythera
    ];
  };
})
