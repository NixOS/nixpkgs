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
  version = "1.4.0";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia-sq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+6QVRp0zDJIIv23YlAI/cspHuGc+YcWdPfJZIOxQRW8=";
  };

  cargoHash = "sha256-I6hPpRpILV+iU9erfVBQOXuICx4IvWvGyHWdep7jRm4=";

  strictDeps = true;
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
    installManPage ${finalAttrs.env.ASSET_OUT_DIR}/man-pages/*.*
    installShellCompletion \
      --cmd sq \
      --bash ${finalAttrs.env.ASSET_OUT_DIR}/shell-completions/sq.bash \
      --fish ${finalAttrs.env.ASSET_OUT_DIR}/shell-completions/sq.fish \
      --zsh ${finalAttrs.env.ASSET_OUT_DIR}/shell-completions/_sq
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line application exposing a useful set of OpenPGP functionality for common tasks";
    homepage = "https://sequoia-pgp.org/";
    changelog = "https://gitlab.com/sequoia-pgp/sequoia-sq/-/blob/v${finalAttrs.version}/NEWS";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [
      minijackson
      doronbehar
      dvn0
      anish
    ];
    mainProgram = "sq";
  };
})
