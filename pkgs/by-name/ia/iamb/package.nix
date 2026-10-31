{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iamb";
  version = "0.13.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ulyssa";
    repo = "iamb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Bu/BDaf9KPoevx/yTQktWUF36REGVyJamuPdrXdMZ/A=";
  };

  cargoHash = "sha256-GZQk7bw8VFq6gEiJ2sLgbkvTACKxZlNbkI54cHt5dVc=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  postInstall = ''
    installManPage $src/docs/iamb.{1,5}
    install -D $src/docs/iamb.svg -t $out/share/icons/hicolor/scalable/apps
    install -D $src/docs/iamb.metainfo.xml $out/share/appdata/chat.iamb.iamb.appdata.xml
    install -D $src/iamb.desktop -t $out/share/applications
    install -Dm644 $src/themes/*.toml -t $out/share/iamb/themes

    # iamb finds its themes only in $XDG_DATA_DIRS/iamb/themes, and neither nix-shell,
    # macOS nor NixOS profiles (share/iamb is not in pathsToLink) put them there
    wrapProgram $out/bin/iamb --suffix XDG_DATA_DIRS : $out/share
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
