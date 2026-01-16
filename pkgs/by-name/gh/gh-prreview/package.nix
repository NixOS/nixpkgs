{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gh-prreview";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "gh-tui-tools";
    repo = "gh-review-conductor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gNQmO+Sa9n+hfy5CBSPqSXhHTzZz8D1sLrNqs+z9Rx4=";
  };

  vendorHash = "sha256-xAOTSdyNRZDKDPnCrvaepBOTDrnHLEA53K5TBxkqbDM=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/chmouel/gh-prreview/cmd.version=${finalAttrs.version}"
  ];

  # Tests require GitHub authentication and network access
  doCheck = false;

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
