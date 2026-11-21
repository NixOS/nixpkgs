{
  lib,
  buildGo127Module,
  fetchFromGitHub,
}:

buildGo127Module (finalAttrs: {
  pname = "op-forward";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "ekovshilovsky";
    repo = "op-forward";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cWkX3DjSgOdZcGEI3P3ucBiFOUi+VmTGFia6ofwdMGw=";
  };

  vendorHash = "sha256-JjXY4EargMoCMtmcUHyQwFRnMMyBUoZTm0ROgnwJ8wg=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ekovshilovsky/op-forward/cmd.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Forward 1Password CLI commands across SSH boundaries with biometric authentication";
    homepage = "https://github.com/ekovshilovsky/op-forward";
    changelog = "https://github.com/ekovshilovsky/op-forward/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ekovshilovsky ];
    mainProgram = "op-forward";
    platforms = lib.platforms.unix;
  };
})
