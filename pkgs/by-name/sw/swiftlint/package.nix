{
  stdenvNoCC,
  lib,
  fetchurl,
  unzip,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:
stdenvNoCC.mkDerivation rec {
  pname = "swiftlint";
  version = "0.62.1";

  src = fetchurl {
    url = "https://github.com/realm/SwiftLint/releases/download/${version}/portable_swiftlint.zip";
    hash = "sha256-VB20vZT4z4+6q3YvWX5/DkkBan+MpccNhrQ3CnzSNkE=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    unzip
    installShellFiles
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -Dm755 swiftlint $out/bin/swiftlint
    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    installShellCompletion --cmd swiftlint \
      --bash <($out/bin/swiftlint --generate-completion-script bash) \
      --fish <($out/bin/swiftlint --generate-completion-script fish) \
      --zsh <($out/bin/swiftlint --generate-completion-script zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to enforce Swift style and conventions";
    homepage = "https://realm.github.io/SwiftLint/";
    license = lib.licenses.mit;
    mainProgram = "swiftlint";
    maintainers = with lib.maintainers; [
      matteopacini
      DimitarNestorov
    ];
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
