{
  lib,
  buildGoModule,
  fetchFromGitHub,
  alsa-lib,
}:

buildGoModule (finalAttrs: {
  pname = "signls";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "emprcl";
    repo = "signls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w/Au7sHh1wvDWHuVx7ClCFnXj8hG7UooZv5MDBNauz0=";
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
