{
  lib,
  fetchurl,
  stdenv,
  jre,
  makeWrapper,
  nix-update-script,
  jdk25,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kotlin-cli";
  version = "0.11.1";

  src = fetchurl {
    url = "https://packages.jetbrains.team/maven/p/amper/amper/org/jetbrains/kotlin/kotlin-cli/${finalAttrs.version}/kotlin-cli-${finalAttrs.version}-dist.tgz";
    hash = "sha256-De0qQ09r8ZOyTiptVsO6RD9CMnIRVaZaqoNyeJQSES8=";
  };
  sourceRoot = ".";
  dontBuild = true;
  nativeBuildInputs = [ makeWrapper ];

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    mkdir -p $out/share/kotlin-cli
    cp -r * $out/share/kotlin-cli/

    mkdir -p $out/bin
    chmod +x $out/share/kotlin-cli/bin/launcher.sh

    # Override amper runtime JVM.
    sed -i 's|^[[:space:]]*jre_url=.*|  jre_url=""|' $out/share/kotlin-cli/bin/launcher.sh
    sed -i 's|^[[:space:]]*jre_target_dir=.*|  jre_target_dir="${jdk25}"|' $out/share/kotlin-cli/bin/launcher.sh

    # Create the missing .flag file to satisfy the runtime check
    touch $out/share/kotlin-cli/.flag

    # Override kotlin toolchain launcher JVM.
    makeWrapper $out/share/kotlin-cli/bin/launcher.sh $out/bin/kotlin \
      --set KOTLIN_CLI_JAVA_HOME "${jdk25.home}"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--url=https://github.com/JetBrains/kotlin-toolchain"
    ];
  };

  meta = {
    description = "Kotlin Toolchain CLI";
    homepage = "https://github.com/JetBrains/kotlin-toolchain";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dshatz ];
    platforms = jre.meta.platforms;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    mainProgram = "kotlin";
  };
})
