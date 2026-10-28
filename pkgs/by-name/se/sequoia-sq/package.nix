{
  fetchFromGitLab,
  lib,
  nettle,
  nix-update-script,
  rustPlatform,
  pkg-config,
  capnproto,
  installShellFiles,
  openssl,
  cacert,
  sqlite,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sequoia-sq";
  version = "1.5.0";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia-sq";
    tag = "sequoia-sq/v${finalAttrs.version}";
    hash = "sha256-DLJ32QGFbCNcIDZnNAx+JCP7xvL+Qoy3Eju1/xCu/AA=";
  };

  cargoHash = "sha256-mYrDtPE010isOdGpq70sRzB02y9Tiiei0S1McOM4AVM=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    capnproto
    installShellFiles
  ];

  buildInputs = [
    openssl
    sqlite
    nettle
  ];

  # Needed for tests to be able to create a ~/.local/share/sequoia directory
  # Needed for avoiding "OpenSSL error" since 1.2.0
  preCheck = ''
    export HOME=$(mktemp -d)
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
  '';

  env.ASSET_OUT_DIR = "target";

  # key store daemon binds a loopback socket
  __darwinAllowLocalNetworking = true;

  doCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  postInstall = ''
    installManPage tool/${finalAttrs.env.ASSET_OUT_DIR}/man-pages/*.*
    installShellCompletion \
      --cmd sq \
      --bash tool/${finalAttrs.env.ASSET_OUT_DIR}/shell-completions/sq.bash \
      --fish tool/${finalAttrs.env.ASSET_OUT_DIR}/shell-completions/sq.fish \
      --zsh tool/${finalAttrs.env.ASSET_OUT_DIR}/shell-completions/_sq
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=sequoia-sq/v(.*)" ];
  };

  meta = {
    description = "Command line application exposing a useful set of OpenPGP functionality for common tasks";
    homepage = "https://sequoia-pgp.org/";
    changelog = "https://gitlab.com/sequoia-pgp/sequoia-sq/-/blob/${finalAttrs.src.tag}/tool/NEWS";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [
      doronbehar
      dvn0
      anish
    ];
    mainProgram = "sq";
  };
})
