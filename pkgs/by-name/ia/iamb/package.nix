{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iamb";
  version = "0.0.12";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ulyssa";
    repo = "iamb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-66DN5tIqR5ppTVDqo3xoG3gl6rZrnikLsls/hqXAhb8=";
  };

  cargoHash = "sha256-gtkloBKCFdKskKmHw0YWX/x13I/ZyUHycm/7ZrRQCBI=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage $src/docs/iamb.{1,5}
    install -D $src/docs/iamb.svg -t $out/share/icons/hicolor/scalable/apps
    install -D $src/docs/iamb.metainfo.xml $out/share/appdata/chat.iamb.iamb.appdata.xml
    install -D $src/iamb.desktop -t $out/share/applications
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Matrix client for Vim addicts";
    mainProgram = "iamb";
    homepage = "https://github.com/ulyssa/iamb";
    changelog = "https://github.com/ulyssa/iamb/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ meain ];
  };
})
