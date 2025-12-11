{
  fetchFromGitHub,
  fuse3,
  installShellFiles,
  zulu25,
  lib,
  makeShellWrapper,
  maven,
  nix-update-script,
  stdenv,
  versionCheckHook,
}:

let
  jdk = zulu25;
in
maven.buildMavenPackage rec {
  pname = "cryptomator-cli";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "cryptomator";
    repo = "cli";
    tag = version;
    hash = "sha256-rwARleKktGXmumIBmrPrfls4EywBqGBxOaB8/ka5ds0=";
  };

  mvnJdk = jdk;
  mvnParameters = "-Dmaven.test.skip=true";
  mvnHash = "sha256-54DT4C+WzyUBPxayA9YnB9I/Igd19iZygByUh5of51I=";

  env = {
    APP_VERSION = version;
    SEMVER_STR = version;
  };

  nativeBuildInputs = [
    jdk
    makeShellWrapper
    installShellFiles
  ];

  # Based on the build_linux.sh script and jpackage configuration
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin/ $out/share/cryptomator-cli/libs/ $out/share/cryptomator-cli/mods/
    mkdir -p $out/share/bash-completion/completions/

    # Copy dependencies
    cp target/libs/* $out/share/cryptomator-cli/libs/
    cp target/mods/* target/cryptomator-cli-*.jar $out/share/cryptomator-cli/mods/

    installShellCompletion --bash target/cryptomator-cli_completion.sh

    # Determine native access package based on architecture
    NATIVE_ACCESS_PACKAGE=${
      if stdenv.hostPlatform.isx86_64 then
        "org.cryptomator.jfuse.linux.amd64"
      else if stdenv.hostPlatform.isAarch64 then
        "org.cryptomator.jfuse.linux.aarch64"
      else
        "no.native.access.available"
    }

    # Create wrapper script
    makeShellWrapper ${jdk}/bin/java $out/bin/cryptomator-cli \
      --add-flags "--enable-native-access=$NATIVE_ACCESS_PACKAGE,org.fusesource.jansi" \
      --add-flags "--class-path '$out/share/cryptomator-cli/libs/*'" \
      --add-flags "--module-path '$out/share/cryptomator-cli/mods'" \
      --add-flags "-Dfile.encoding='utf-8'" \
      --add-flags "-Dorg.cryptomator.cli.version='${version}'" \
      --add-flags "-Xss5m" \
      --add-flags "-Xmx256m" \
      --add-flags "--module org.cryptomator.cli/org.cryptomator.cli.CryptomatorCli" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ fuse3 ]}" \
      --set JAVA_HOME "${jdk.home}"

    runHook postInstall
  '';

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line program to access encrypted Cryptomator vaults";
    homepage = "https://github.com/cryptomator/cli";
    changelog = "https://github.com/cryptomator/cli/releases/tag/${version}";
    license = lib.licenses.agpl3Plus;
    mainProgram = "cryptomator-cli";
    maintainers = with lib.maintainers; [
      masrlinu
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # maven dependencies
    ];
  };
}
