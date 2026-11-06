{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "lark-cli";
  version = "1.0.99";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "larksuite";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9QRpUgsoUSCArlXMh8dRaVIeqV+HtTgoUuxI9uZvhRY=";
  };

  vendorHash = "sha256-5ecTHuvSeSUVVC3hI/nzZsRFjl7ppgTY3NHuHB4pojA=";

  subPackages = [ "." ];

  postInstall = ''
    mv $out/bin/cli $out/bin/lark-cli
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/larksuite/cli/internal/build.Version=v${finalAttrs.version}"
    "-X github.com/larksuite/cli/internal/build.Date=2026-06-01"
  ];

  passthru.updateScript = nix-update-script { };

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "lark-cli --version";
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "The official CLI for Lark/Feishu open platform";
    homepage = "https://github.com/larksuite/cli";
    changelog = "https://github.com/larksuite/cli/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zehuajun ];
    mainProgram = "lark-cli";
  };
})
