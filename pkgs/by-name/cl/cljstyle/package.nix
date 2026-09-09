{
  lib,
  buildGraalvmNativeImage,
  fetchMavenArtifact,
  fetchurl,
  versionCheckHook,
}:

buildGraalvmNativeImage (finalAttrs: {
  pname = "cljstyle";
  version = "0.17.642";

  src = fetchurl {
    url = "https://github.com/greglook/cljstyle/releases/download/${finalAttrs.version}/cljstyle-${finalAttrs.version}.jar";
    hash = "sha256-AkCuTZeDXbNBuwPZEMhYGF/oOGIKq5zVDwL8xwnj+mE=";
  };

  extraNativeImageBuildArgs = [
    "-H:+ReportExceptionStackTraces"
    "--no-fallback"
    "-cp ${finalAttrs.finalPackage.passthru.graal-build-time.passthru.jar}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "version" ];

  # must be on classpath to build native image
  passthru.graal-build-time = fetchMavenArtifact {
    repos = [ "https://repo.clojars.org/" ];
    groupId = "com.github.clj-easy";
    artifactId = "graal-build-time";
    version = "1.0.5";
    hash = "sha256-M6/U27a5n/QGuUzGmo8KphVnNa2K+LFajP5coZiFXoY=";
  };

  meta = {
    description = "Tool for formatting Clojure code";
    homepage = "https://github.com/greglook/cljstyle";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.epl10;
    changelog = "https://github.com/greglook/cljstyle/blob/${finalAttrs.version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ psyclyx ];
    mainProgram = "cljstyle";
  };
})
