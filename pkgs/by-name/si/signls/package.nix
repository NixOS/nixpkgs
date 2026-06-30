{
  lib,
  buildGoModule,
  fetchFromGitHub,
  alsa-lib,
}:

buildGoModule (finalAttrs: {
  pname = "signls";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "emprcl";
    repo = "signls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FXXvFwdWYJ55YSL7OetQpyf7U8Z60o4hEjJFSzESq34=";
  };

  buildInputs = [
    alsa-lib
  ];

  vendorHash = "sha256-kr/S+iO0fHTF3KM3nMdGtFhFIkxkpQOZRHFWcXNTvJk=";

  ldflags = [
    "-s"
    "-w"
    "-X main.AppVersion=v${finalAttrs.version}"
  ];

  meta = {
    description = "Non-linear, generative midi sequencer in the terminal";
    homepage = "https://github.com/emprcl/signls";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "signls";
  };
})
