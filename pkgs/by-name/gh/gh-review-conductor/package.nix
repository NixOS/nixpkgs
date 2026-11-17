{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gh-review-conductor";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "gh-tui-tools";
    repo = "gh-review-conductor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B6wjZoBGltfb/qsApzoPPFG1w1f7AyuCAvQVSVtkX4M=";
  };

  vendorHash = "sha256-xAOTSdyNRZDKDPnCrvaepBOTDrnHLEA53K5TBxkqbDM=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/gh-tui-tools/gh-review-conductor/cmd.version=${finalAttrs.version}"
  ];

  # Tests require GitHub authentication and network access
  doCheck = false;

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GitHub CLI extension to apply PR review comments and suggestions directly to your local code";
    homepage = "https://github.com/gh-tui-tools/gh-review-conductor";
    changelog = "https://github.com/gh-tui-tools/gh-review-conductor/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      vdemeester
      chmouel
    ];
    mainProgram = "gh-prreview";
  };
})
