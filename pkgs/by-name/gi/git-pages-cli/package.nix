{
  buildGoModule,
  fetchFromCodeberg,
  lib,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "git-pages-cli";
  version = "1.10.1";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "git-pages";
    repo = "git-pages-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+M2A1ApHwmRz3SuVZX93iFKWPyuM1Ox0oTf9mEWT3L0=";
  };

  vendorHash = "sha256-dmCIljjr0wDBDR9/OiudySeKxUGW5rg69K1N25i1wEM=";

  ldflags = [
    "-X"
    "main.versionOverride=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v(.*)"
    ];
  };

  meta = {
    description = "Command-line application for uploading a site to a git-pages server";
    homepage = "https://codeberg.org/git-pages/git-pages-cli";
    changelog = "https://codeberg.org/git-pages/git-pages-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd0;
    mainProgram = "git-pages-cli";
    maintainers = with lib.maintainers; [ dramforever ];
  };
})
