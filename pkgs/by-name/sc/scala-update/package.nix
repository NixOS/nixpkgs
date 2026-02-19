{
  lib,
  stdenvNoCC,
  coursier,
  buildGraalvmNativeImage,
}:

buildGraalvmNativeImage (finalAttrs: {
  pname = "scala-update";
  version = "0.2.2";

  buildInputs = [ finalAttrs.finalPackage.passthru.deps ];

  src = "${finalAttrs.finalPackage.passthru.deps}/share/java/scala-update_2.13-${finalAttrs.version}.jar";

  extraNativeImageBuildArgs = [
    "--no-fallback"
    "--enable-url-protocols=https"
    "update.Main"
  ];

  buildPhase = ''
    runHook preBuild

    native-image ''${nativeImageArgs[@]} -cp $(JARS=("${finalAttrs.finalPackage.passthru.deps}/share/java"/*.jar); IFS=:; echo "''${JARS[*]}")

    runHook postBuild
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/scala-update --version | grep -q "${finalAttrs.version}"

    runHook postInstallCheck
  '';

  passthru.deps = stdenvNoCC.mkDerivation {
    name = "scala-update-deps-${finalAttrs.version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${lib.getExe coursier} fetch io.github.kitlangton:scala-update_2.13:${finalAttrs.version} > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "kNnFzzHn+rFq4taqRYjBYaDax0MHW+vIoSFVN3wxA8M=";
  };

  meta = {
    description = "Update your Scala dependencies interactively";
    homepage = "https://github.com/kitlangton/scala-update";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.rtimush ];
    mainProgram = "scala-update";
  };
})
