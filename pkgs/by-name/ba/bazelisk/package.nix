{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "bazelisk";
  version = "1.31.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazelisk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-axKP+88ELTRWPgkjYbQ5icLtVH7HeyoQ1ITAxAdkIS4=";
  };

  vendorHash = "sha256-ISnsLuk3+FbpCiQmcyCuPq3vz2uVEawtto0F9NRo9vo=";

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
    maintainers = with lib.maintainers; [
      hythera
    ];
  };
})
