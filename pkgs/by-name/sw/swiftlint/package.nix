{
  stdenvNoCC,
  lib,
  fetchurl,
  unzip,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:
let
  sources = lib.importJSON ./sources.json;
  platform =
    sources.platforms.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported platform: ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "swiftlint";
  inherit (sources) version;

  src = fetchurl {
    url = "https://github.com/realm/SwiftLint/releases/download/${finalAttrs.version}/${platform.filename}";
    inherit (platform) hash;
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    unzip
    installShellFiles
  ];

  sourceRoot = ".";

  installPhase =
    let
      binary = if stdenvNoCC.hostPlatform.isLinux then "swiftlint-static" else "swiftlint";
    in
    ''
      runHook preInstall
      install -Dm755 ${binary} $out/bin/swiftlint
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
    platforms = lib.attrNames sources.platforms;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
