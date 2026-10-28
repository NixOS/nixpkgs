{
  buildGoModule,
  fetchFromCodeberg,
  lib,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "git-pages-cli";
  version = "1.11.2";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "git-pages";
    repo = "git-pages-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-E+O6WLZH5kzRakL/gM/bja149IHmB5r5u5yl16+/Bkc=";
  };

  vendorHash = "sha256-0/UY95xWVqIbi/SMoF12CdVp7S36qVI+Q5s2LzEtutI=";

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
