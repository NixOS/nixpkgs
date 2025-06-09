{
  lib,
  buildGraalvmNativeImage,
  fetchMavenArtifact,
  fetchurl,
  graalvmPackages,
  versionCheckHook,
}:

let
  pname = "cljstyle";
  version = "0.17.642";

  # must be on classpath to build native image
  graal-build-time = fetchMavenArtifact {
    repos = [ "https://repo.clojars.org/" ];
    groupId = "com.github.clj-easy";
    artifactId = "graal-build-time";
    version = "1.0.5";
    hash = "sha256-M6/U27a5n/QGuUzGmo8KphVnNa2K+LFajP5coZiFXoY=";
  };
in
buildGraalvmNativeImage {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/greglook/${pname}/releases/download/${version}/${pname}-${version}.jar";
    hash = "sha256-AkCuTZeDXbNBuwPZEMhYGF/oOGIKq5zVDwL8xwnj+mE=";
  };

  graalvmDrv = graalvmPackages.graalvm-ce;

  extraNativeImageBuildArgs = [
    "-H:+ReportExceptionStackTraces"
    "--no-fallback"
    "-cp ${graal-build-time.passthru.jar}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "version" ];

  meta = {
    description = "Tool for formatting Clojure code";
    homepage = "https://github.com/greglook/cljstyle";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.epl10;
    changelog = "https://github.com/greglook/cljstyle/blob/${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ psyclyx ];
    mainProgram = "cljstyle";
  };
}
