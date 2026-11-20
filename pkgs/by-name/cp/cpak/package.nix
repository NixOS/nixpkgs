{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "cpak";
  version = "2.14.4";

  src = fetchFromGitHub {
    owner = "Containerpak";
    repo = "cpak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NbrbvcHLwjOl0LBTMqVq9pio0J0t+Oma4SLuRZGZFWs=";
  };

  vendorHash = "sha256-Sqakbm9QulHh05lxZ4CGvIdHVTIziCTr4SxfIslwIU0=";

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
