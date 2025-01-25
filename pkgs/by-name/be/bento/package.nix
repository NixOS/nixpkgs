{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "bento";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "warpstreamlabs";
    repo = "bento";
    tag = "v${version}";
    hash = "sha256-ukmmmvc5CWctDO+YaW/PiqWizfXtgbcMlIK6PjhxMm4=";
  };

  vendorHash = "sha256-G67i4tZoevlrj+LhjCoHReoWkIZUQVt4YBavmj+h2OI=";

  subPackages = [
    "cmd/bento"
    "cmd/serverless/bento-lambda"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/warpstreamlabs/bento/internal/cli.Version=${version}"
    "-X main.Version=${version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High performance and resilient stream processor";
    homepage = "https://warpstreamlabs.github.io/bento/";
    changelog = "https://github.com/warpstreamlabs/bento/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "bento";
    badPlatforms = [
      # cannot find module providing package github.com/microsoft/gocosmos
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
