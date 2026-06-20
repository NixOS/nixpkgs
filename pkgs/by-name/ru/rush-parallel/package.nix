{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "rush-parallel";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "rush";
    rev = "v${finalAttrs.version}";
    hash = "sha256-K1DKwG22anoiLBSFC2S5WJkY0tFozTwbHZx9PNCGJLA=";
  };

  vendorHash = "sha256-1q5qD496PfK/4LnVI6FWuHorg8EseqodAM7NCB03Lt8=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Cross-platform command-line tool for executing jobs in parallel";
    homepage = "https://github.com/shenwei356/rush";
    changelog = "https://github.com/shenwei356/rush/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "rush-parallel";
  };
})
