{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "brows";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "rubysolo";
    repo = "brows";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M31UiNh8PmE8lZH0u675iHkmW0nXqzz4+flrZO2r0lE=";
  };

  vendorHash = "sha256-m6kNEWr41BQd4TdsYWXWBaTJCxLBHQL6xVaThUOcCKM=";

  ldflags = [
    "-X main.Version=${finalAttrs.version}"
  ];

  __structuredAttrs = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    description = "CLI tool to browse GitHub releases";
    mainProgram = "brows";
    homepage = "https://github.com/rubysolo/brows";
    changelog = "https://github.com/rubysolo/brows/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kangazero
    ];
  };
})
