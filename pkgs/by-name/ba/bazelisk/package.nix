{
  lib,
  buildGoModule,
  fetchFromGitHub,
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

  meta = {
    description = "User-friendly launcher for Bazel";
    mainProgram = "bazelisk";
    longDescription = ''
      BEWARE: This package does not work on NixOS.
    '';
    homepage = "https://github.com/bazelbuild/bazelisk";
    changelog = "https://github.com/bazelbuild/bazelisk/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
