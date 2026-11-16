{
  lib,
  rustPlatform,
  fetchFromSourcehut,
  pkg-config,
  sqlite,
  installShellFiles,
  makeWrapper,
  xandikos,
  cacert,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pimsync";
  version = "0.7.0";

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = "pimsync";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7/GxRkB714l/pIWlw0l0DHd2kokGa8WR6cLI+7wORMY=";
  };

  cargoHash = "sha256-iSg+iBlgi2GC/KWlau3lhGaEyJ1ovAxG2B1ALm8d2wE=";

  env.PIMSYNC_VERSION = finalAttrs.version;

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    installShellFiles
  ];

  buildInputs = [
    sqlite
  ];

  nativeCheckInputs = [
    xandikos
    cacert
  ];

  postInstall = ''
    installManPage pimsync.1 pimsync.conf.5 pimsync-migration.7
    installShellCompletion --zsh contrib/_pimsync
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Synchronise calendars and contacts";
    homepage = "https://git.sr.ht/~whynothugo/pimsync";
    changelog = "https://pimsync.whynothugo.nl/changelog.html#v${
      lib.replaceString "." "-" finalAttrs.version
    }";
    license = lib.licenses.eupl12;
    platforms = lib.platforms.unix;
    maintainers = [
      lib.maintainers.qxrein
      lib.maintainers.antonmosich
    ];
    mainProgram = "pimsync";
  };
})
