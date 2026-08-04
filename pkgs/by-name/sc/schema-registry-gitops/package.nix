{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  gradle,
  makeWrapper,
  kotlin,
  jre,
  temurin-bin-17,
}:

let
  jdk = temurin-bin-17;
  gradleOverlay = gradle.override { java = jdk; };
  kotlinOverlay = kotlin.override { jre = jdk; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "schema-registry-gitops";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "domnikl";
    repo = "schema-registry-gitops";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YWmCRA252jpqYBiRlZdyPaum18LNdcDK2ghdpAocd5c=";
  };

  nativeBuildInputs = [
    gradleOverlay
    kotlinOverlay
    jdk
    makeWrapper
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  # this is required for using mitm-cache on Darwin
  __darwinAllowLocalNetworking = true;

  gradleFlags = [ "-Dfile.encoding=utf-8" ];

  gradleBuildTask = "shadowJar";

  installPhase = ''
    mkdir -p $out/{bin,share/${finalAttrs.pname}}
    cp build/libs/${finalAttrs.pname}.jar $out/share/${finalAttrs.pname}

    makeWrapper ${lib.getExe jre} $out/bin/${finalAttrs.pname} \
      --add-flags "-jar $out/share/${finalAttrs.pname}/${finalAttrs.pname}.jar"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Manage Confluent Schema Registry subjects through Infrastructure as code";
    homepage = "https://github.com/domnikl/schema-registry-gitops";
    changelog = "https://github.com/domnikl/schema-registry-gitops/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "schema-registry-gitops";
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
  };
})
