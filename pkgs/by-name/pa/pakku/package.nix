{
  jre,
  lib,
  stdenv,
  gradle,
  makeWrapper,
  fetchFromGitHub,
  versionCheckHook,
  installShellFiles,
  stripJavaArchivesHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pakku";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "juraj-hrivnak";
    repo = "Pakku";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PVET+A9LVWnqLCXz3R9EP7gk6GOViSzhRLrXTjNFPaA=";
  };

  gradleBuildTask = "jvmJar";

  nativeBuildInputs = [
    gradle
    makeWrapper
    installShellFiles
    stripJavaArchivesHook
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  # this is required for using mitm-cache on Darwin
  __darwinAllowLocalNetworking = true;

  gradleCheckTask = "jvmTest";
  doCheck = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/pakku}
    cp build/libs/pakku.jar $out/share/pakku

    makeWrapper ${jre}/bin/java $out/bin/pakku --add-flags "-jar $out/share/pakku/pakku.jar"

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd pakku \
      --bash <($out/bin/pakku --generate-completion=bash) \
      --fish <($out/bin/pakku --generate-completion=fish) \
      --zsh <($out/bin/pakku --generate-completion=zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Multiplatform modpack manager for Minecraft: Java Edition";
    longDescription = ''
      With Pakku, you can create modpacks for CurseForge, Modrinth or both simultaneously.

      It's a package manager that significantly simplifies Minecraft modpack development, inspired by package managers like npm and Cargo. In addition to package management itself, it enables support for version control, simplifies collaboration options, and adds support for CI/CD.
    '';
    homepage = "https://github.com/juraj-hrivnak/Pakku";
    downloadPage = "https://github.com/juraj-hrivnak/Pakku/releases/tag/v${finalAttrs.version}";
    changelog = "https://github.com/juraj-hrivnak/Pakku/releases/tag/v${finalAttrs.version}";
    mainProgram = "pakku";
    license = lib.licenses.eupl12;
    platforms = jre.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
    maintainers = with lib.maintainers; [ redlonghead ];
  };
})
