{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  stdenv,
  libxcb,
  versionCheckHook,
  withClipboard ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "motus";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "oleiade";
    repo = "motus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lMNXg6YYTxAycxOiVtBGrSHpccLwerIQcY25K/NkqMo=";
  };

  cargoHash = "sha256-6MKEHnB2MJVB4cNvz3JYlhuzxhzsA+Pq5OkpLNoAEyU=";

  buildAndTestSubdir = "crates/motus-cli";

  # The CLI crate version was not bumped to match the v0.4.0 release tag:
  # https://github.com/oleiade/motus/issues/58
  postPatch = ''
    substituteInPlace crates/motus-cli/src/main.rs \
      --replace-fail '#[command(version = "0.3.1")]' '#[command(version = "${finalAttrs.version}")]'
  '';

  buildNoDefaultFeatures = !withClipboard;

  buildInputs = lib.optionals (withClipboard && stdenv.hostPlatform.isLinux) [ libxcb ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dead simple password generator";
    homepage = "https://github.com/oleiade/motus";
    changelog = "https://github.com/oleiade/motus/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ britter ];
    mainProgram = "motus";
  };
})
