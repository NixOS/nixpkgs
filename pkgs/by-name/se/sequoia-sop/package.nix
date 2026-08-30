{
  lib,
  fetchFromGitLab,
  nettle,
  nix-update-script,
  installShellFiles,
  rustPlatform,
  sqlite,
  pkg-config,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sequoia-sop";
  version = "0.38.0";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia-sop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3PxUXMLRBqw9GO0+wRiwI7P6/RH9vuAkSN4OnSxV0SQ=";
  };

  cargoHash = "sha256-iKC6vIT8fVFv/Yx3YJUSCHyTOZ7X860Ak0l/+7lrU9Y=";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    installShellFiles
  ];

  buildInputs = [
    nettle
    sqlite
  ];

  buildFeatures = [ "cli" ];

  env.ASSET_OUT_DIR = "target";

  # Install manual pages
  postInstall = ''
    installManPage ${finalAttrs.env.ASSET_OUT_DIR}/man-pages/*.*
    installShellCompletion --cmd sqop \
      --bash ${finalAttrs.env.ASSET_OUT_DIR}/shell-completions/sqop.bash \
      --fish ${finalAttrs.env.ASSET_OUT_DIR}/shell-completions/sqop.fish \
      --zsh ${finalAttrs.env.ASSET_OUT_DIR}/shell-completions/_sqop
    # Also elv and powershell are generated there
  '';

  doCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Implementation of the Stateless OpenPGP Command Line Interface using Sequoia";
    homepage = "https://gitlab.com/sequoia-pgp/sequoia-sop";
    changelog = "https://gitlab.com/sequoia-pgp/sequoia-sop/-/blob/${finalAttrs.src.tag}/NEWS";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      doronbehar
      anish
    ];
    mainProgram = "sqop";
  };
})
