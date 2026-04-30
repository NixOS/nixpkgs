{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  gradle_9,
  openjdk25_headless,
  libmatthew_java,
  dbus,
  dbus_java,
  callPackage,
  versionCheckHook,
  signal-cli,
}:

let
  gradle = gradle_9;
  libsignal-jni = callPackage ./libsignal-jni.nix { jdk = openjdk25_headless; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "signal-cli";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "AsamK";
    repo = "signal-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YG7R/P6X/oznRCllLnoEAkx+hjR/cGD0TTiijbATsLo=";
  };

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libmatthew_java
    dbus
    dbus_java
  ];

  mitmCache = gradle.fetchDeps {
    pkg = signal-cli;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  # Use the JDK for building
  gradleFlags = [
    "-Dfile.encoding=utf-8"
    "-Dorg.gradle.java.home=${openjdk25_headless}"
  ];

  gradleBuildTask = "installDist";

  preGradleUpdate = ''
    gradle assemble
  '';

  # Tests require network access and a running signal server
  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/bin

    cp build/install/signal-cli/lib/* $out/lib/
    cp ${libsignal-jni}/lib/* $out/lib/
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    makeWrapper ${openjdk25_headless}/bin/java $out/bin/signal-cli \
      --set JAVA_HOME "${openjdk25_headless}" \
      --add-flags "--enable-native-access=ALL-UNNAMED" \
      --add-flags "-classpath '$out/lib/*:${libmatthew_java}/lib/jni'" \
      --add-flags "-Djava.library.path=$out/lib:${libmatthew_java}/lib/jni:${dbus_java}/share/java/dbus" \
      --add-flags "org.asamk.signal.Main"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    makeWrapper ${openjdk25_headless}/bin/java $out/bin/signal-cli \
      --set JAVA_HOME "${openjdk25_headless}" \
      --add-flags "--enable-native-access=ALL-UNNAMED" \
      --add-flags "-classpath '$out/lib/*'" \
      --add-flags "-Djava.library.path=$out/lib" \
      --add-flags "org.asamk.signal.Main"
  ''
  + ''
    runHook postInstall
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    homepage = "https://github.com/AsamK/signal-cli";
    description = "Command-line and dbus interface for communicating with the Signal messaging service";
    mainProgram = "signal-cli";
    changelog = "https://github.com/AsamK/signal-cli/blob/v${finalAttrs.version}/CHANGELOG.md";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = lib.licenses.gpl3;
    maintainers = [
      lib.maintainers.klea
      lib.maintainers.akosseres
    ];
    platforms = lib.platforms.unix;
  };
})
