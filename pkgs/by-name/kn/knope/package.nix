{
  fetchFromGitHub,
  git,
  lib,
  libgit2,
  nix-update-script,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "knope";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "knope-dev";
    repo = "knope";
    tag = "knope/v${finalAttrs.version}";
    hash = "sha256-nxWk95WxpUjTZiGczY75eaTeRnr8MmPeThzzb38wgNI=";
  };

  cargoHash = "sha256-TgPs05Wgb1bODhc1+XDupLzs31T3Oeg6IC7ipmYgipI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libgit2 ];

  env.LIBGIT2_NO_VENDOR = 1;

  nativeCheckInputs = [ git ];
  nativeInstallCheckInputs = [ versionCheckHook ];

  __structuredAttrs = true;
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "knope/v(.*)"
    ];
  };

  meta = {
    changelog = "https://github.com/knope-dev/knope/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Automation for changelogs and releases using conventional commits and/or changesets";
    homepage = "https://knope.tech/";
    mainProgram = "knope";
    maintainers = with lib.maintainers; [ mdaniels5757 ];
    license = lib.licenses.mit;
  };
})
