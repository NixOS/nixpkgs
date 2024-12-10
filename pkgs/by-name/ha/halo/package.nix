{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  # official jre size is 500MB, but temurin-jre-bin is 100MB.
  temurin-jre-bin,
}:
stdenv.mkDerivation rec {
  pname = "halo";
  version = "2.20.5";
  src = fetchurl {
    url = "https://github.com/halo-dev/halo/releases/download/v${version}/halo-${version}.jar";
    hash = "sha256-VGSSGc2caNO7+IK1ArqjZGz+LaHWZsaO68Jr06BCcfE=";
  };

  nativeBuildInputs = [
    makeWrapper
    temurin-jre-bin
  ];

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    cp $src halo.jar
    # Extract the jar file.
    # Because jar vs extract, jar startup time is 4s slower than extract.
    java -Djarmode=tools -jar halo.jar extract --layers --launcher
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/halo
    find halo -type d -empty -delete
    for target in halo/*; do
      cp -r $target/* $out/share/halo
    done

    # 'HALO_WORK_DIR'
    # Set the working directory for halo, then plug-ins and other content will be stored in this directory.
    # Note: that the '/' symbol is not required at the end of the path.
    # default: /var/lib/halo
    # 'JVM_OPTS'
    # Note: 'apache.lucene' requires us to set HotspotVMOptions.
    # You can override this via environment variables.
    # default: -Xms256m -Xmx256m
    # 'SPRING_CONFIG_LOCATION'
    # Note: 'spring.config.location' is used to specify the configuration file location.
    # Warning: This variable is based on "HALO_WORK_DIR", you do not need and should not set or override it.
    mkdir -p $out/bin
    makeWrapper ${temurin-jre-bin}/bin/java $out/bin/halo \
      --chdir $out/share/halo \
      --set-default HALO_WORK_DIR "/var/lib/halo" \
      --set-default JVM_OPTS "-Xms256m -Xmx256m" \
      --set SPRING_CONFIG_LOCATION "optional:classpath:/;optional:file:\`\$HALO_WORK_DIR\`/" \
      --add-flags "-server \$JVM_OPTS" \
      --add-flags "org.springframework.boot.loader.launch.JarLauncher"

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.halo.run";
    description = "Self-hosted dynamic blogging program";
    maintainers = with lib.maintainers; [ yah ];
    license = lib.licenses.gpl3Only;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "halo";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
}
