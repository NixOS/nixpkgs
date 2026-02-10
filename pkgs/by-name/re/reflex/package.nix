{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "reflex";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "cespare";
    repo = "reflex";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-/2qVm2xpSFVspA16rkiIw/qckxzXQp/1EGOl0f9KljY=";
  };

  vendorHash = "sha256-JCtVYDHbhH2i7tGNK1jvgHCjU6gMMkNhQ2ZnlTeqtmA=";

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
