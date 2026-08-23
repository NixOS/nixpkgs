{
  buildGoModule,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "diskbloom";
  version = "0.1.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Zingzy";
    repo = "diskbloom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-199HhM20SPKN0swBetHXMdlf4l/FiUEdv/gttMQr39g=";
  };

  vendorHash = "sha256-gmq3rSjH+zyWG08l2xjNPiGpiEVB1r0xaoZySzrCGGo=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];
  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    homepage = "https://github.com/Zingzy/diskbloom";
    description = "A pastel treemap TUI that shows what's eating your disk";
    platforms = lib.platforms.all;
    license = lib.licenses.asl20;
    mainProgram = "diskbloom";
    maintainers = with lib.maintainers; [ yarn ];
  };
})
