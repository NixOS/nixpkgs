{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  mpv,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "radioboat";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "slashformotion";
    repo = "radioboat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mjmrUWnc2oBuUiKnyKGULILI9mp5JZjXSwkp1WgqcHA=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-YvifggF8XZTzFBUs6u5IzdtPsxehjSNlwIT3Gb6wjW4=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  preFixup = ''
    wrapProgram $out/bin/radioboat --prefix PATH ":" "${lib.makeBinPath [ mpv ]}";
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd radioboat \
      --bash <($out/bin/radioboat completion bash) \
      --fish <($out/bin/radioboat completion fish) \
      --zsh <($out/bin/radioboat completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  doInstallCheck = true;

  meta = {
    description = "Terminal web radio client";
    homepage = "https://github.com/slashformotion/radioboat";
    changelog = "https://github.com/slashformotion/radioboat/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "radioboat";
    platforms = with lib.platforms; linux ++ darwin;
  };
})
