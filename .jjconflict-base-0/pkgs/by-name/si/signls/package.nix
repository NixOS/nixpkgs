{
  lib,
  buildGoModule,
  fetchFromGitHub,
  alsa-lib,
}:

buildGoModule (finalAttrs: {
  pname = "signls";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "emprcl";
    repo = "signls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fITsfMgMdv6zW4KEmteCYQdm2NfI2RLbrW44KOwtLOg=";
  };

  buildInputs = [
    alsa-lib
  ];

  vendorHash = "sha256-reNMOb8QRJ+nMa7S2aM/f8wur0yeMDks2b6Skh6uTQQ=";

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
