{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "cpak";
  version = "2.14.8";

  src = fetchFromGitHub {
    owner = "Containerpak";
    repo = "cpak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n/uHhOzZvKUE6QSZ6LRBLGOvm9LRibKB2DRFsSwYhEk=";
  };

  vendorHash = "sha256-+JB2fxN/EAABtzh1o+S/SOxpNa0VQ2LHEEg18Z6KtA8=";

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
