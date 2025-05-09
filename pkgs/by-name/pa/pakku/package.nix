{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle,
  makeWrapper,
  installShellFiles,
  jdk17,
  pakku,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pakku";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "juraj-hrivnak";
    repo = "Pakku";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JvEVEsvyOFJpWjnwWi5/b2+WUTPuNPtUUL46fsiVu/c=";
  };

  nativeBuildInputs = [
    gradle
    makeWrapper
    installShellFiles
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleFlags = [ "-Dfile.encoding=utf-8" ];
  gradleBuildTask = "jvmJar";

  installPhase = ''
    mkdir -p $out/{bin,share/pakku}
    ls -la
    cp build/libs/pakku.jar $out/share/pakku

    makeWrapper ${jdk17}/bin/java $out/bin/pakku \
      --add-flags "-jar $out/share/pakku/pakku.jar"

    runHook postInstall
  '';

  postInstall = ''
    installShellCompletion --cmd pakku \
      --bash <($out/bin/pakku --generate-completion=bash) \
      --fish <($out/bin/pakku --generate-completion=fish) \
      --zsh <($out/bin/pakku --generate-completion=zsh)
  '';

  meta = {
    description = "Multiplatform modpack manager for Minecraft: Java Edition";
    homepage = "https://github.com/juraj-hrivnak/Pakku";
    changelog = "https://github.com/juraj-hrivnak/Pakku/releases/tag/v${finalAttrs.version}";

    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];

    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ squawkykaka ];
    mainProgram = "pakku";
    platforms = lib.platforms.all;
  };
})
