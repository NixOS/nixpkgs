{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "cpak";
  version = "2.12.7";

  src = fetchFromGitHub {
    owner = "Containerpak";
    repo = "cpak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bISKyH1+Yr1EBzZYIK0xpe0jmBiWtCnByz4Ng01QJCI=";
  };

  vendorHash = "sha256-cgqb2AY06Ru+JJIK7vyaLSPyjJqiLvNytvSQCgDOASc=";

  subPackages = [
    "."
    "cmd/cpak-storaged"
    "cmd/cpak-sign"
  ];

  tags = [ "cpak_ui_builtin" ];

  __structuredAttrs = true;

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.selfUpdateMode=disabled"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Decentralized, portable, low-overhead containerized application format for Linux";
    homepage = "https://cpak.it";
    changelog = "https://github.com/Containerpak/cpak/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ rachalaraj ];
    mainProgram = "cpak";
    platforms = lib.platforms.linux;
  };
})
