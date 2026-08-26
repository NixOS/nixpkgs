{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "reflex";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "cespare";
    repo = "reflex";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-qc33ppo+RdhztgCUKPSbVFWlz5FTCEExVHkUre+MR+o=";
  };

  vendorHash = "sha256-QCdhZmuxWUAwCwoLLWqEP6zoBBGh5OpDTz4uLIY0xAg=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Small tool to watch a directory and rerun a command when certain files change";
    mainProgram = "reflex";
    homepage = "https://github.com/cespare/reflex";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nicknovitski ];
  };
})
