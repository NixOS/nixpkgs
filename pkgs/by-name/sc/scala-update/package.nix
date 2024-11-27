{ lib, stdenv, coursier, buildGraalvmNativeImage }:

let
  baseName = "scala-update";
  version = "0.2.2";
  deps = stdenv.mkDerivation {
    name = "${baseName}-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/cs fetch io.github.kitlangton:scala-update_2.13:${version} > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "kNnFzzHn+rFq4taqRYjBYaDax0MHW+vIoSFVN3wxA8M=";
  };
in buildGraalvmNativeImage {
  pname = baseName;
  inherit version;

  buildInputs = [ deps ];

  src = "${deps}/share/java/${baseName}_2.13-${version}.jar";

  extraNativeImageBuildArgs =
    [ "--no-fallback" "--enable-url-protocols=https" "update.Main" ];

  buildPhase = ''
    runHook preBuild

    native-image ''${nativeImageBuildArgs[@]} -cp $(JARS=("${deps}/share/java"/*.jar); IFS=:; echo "''${JARS[*]}")

    runHook postBuild
  '';

  installCheckPhase = ''
    $out/bin/${baseName} --version | grep -q "${version}"
  '';

  meta = with lib; {
    description = "Update your Scala dependencies interactively";
    homepage = "https://github.com/kitlangton/scala-update";
    license = licenses.asl20;
    maintainers = [ maintainers.rtimush ];
  };
}
