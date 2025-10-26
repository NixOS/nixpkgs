{
  lib,
  rustPlatform,
  fetchFromSourcehut,
  pkg-config,
  sqlite,
  installShellFiles,
  makeWrapper,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pimsync";
  version = "0.5.4";

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = "pimsync";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LHdm6CeaGrlTNzN4h9XzYCG5aRG2lk3ZqqZLd37q7is=";
  };

  cargoHash = "sha256-6n7kjmLWzG5rttYak65gmu5KM/W4bN4FS1MaEnCELV8=";

  PIMSYNC_VERSION = finalAttrs.version;

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    installShellFiles
  ];

  buildInputs = [
    sqlite
  ];

  postInstall = ''
    installManPage pimsync.1 pimsync.conf.5 pimsync-migration.7
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
    maintainers = [ lib.maintainers.qxrein ];
    mainProgram = "pimsync";
  };
})
