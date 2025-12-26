{
  stdenvNoCC,
  lib,
  fetchurl,
  makeWrapper,
  openjdk21_headless,
  libmatthew_java,
  dbus,
  dbus_java,
  versionCheckHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "signal-cli";
  version = "0.13.22";

  # Building from source would be preferred, but is much more involved.
  src = fetchurl {
    url = "https://github.com/AsamK/signal-cli/releases/download/v${finalAttrs.version}/signal-cli-${finalAttrs.version}.tar.gz";
    hash = "sha256-FFPChw0w0QqX8ZJnqpwxS5mf2OeDlVW8QQyDjTozOAs=";
  };

  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    libmatthew_java
    dbus
    dbus_java
  ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r lib $out/
    install -Dm755 bin/signal-cli -t $out/bin
  ''
  + (
    if stdenvNoCC.hostPlatform.isLinux then
      ''
        makeWrapper ${openjdk21_headless}/bin/java $out/bin/signal-cli \
          --set JAVA_HOME "${openjdk21_headless}" \
          --add-flags "-classpath '$out/lib/*:${libmatthew_java}/lib/jni'" \
          --add-flags "-Djava.library.path=${libmatthew_java}/lib/jni:${dbus_java}/share/java/dbus:$out/lib" \
          --add-flags "org.asamk.signal.Main"
      ''
    else
      ''
        wrapProgram $out/bin/signal-cli \
          --prefix PATH : ${lib.makeBinPath [ openjdk21_headless ]} \
          --set JAVA_HOME ${openjdk21_headless}
      ''
  )
  + ''
    runHook postInstall
  '';

  # Execution in the macOS (10.13) sandbox fails with
  # dyld: Library not loaded: /System/Library/Frameworks/Cocoa.framework/Versions/A/Cocoa
  #   Referenced from: /nix/store/5ghc2l65p8jcjh0bsmhahd5m9k5p8kx0-zulu1.8.0_121-8.20.0.5/bin/java
  #   Reason: no suitable image found.  Did find:
  #         /System/Library/Frameworks/Cocoa.framework/Versions/A/Cocoa: file system sandbox blocked stat()
  #         /System/Library/Frameworks/Cocoa.framework/Versions/A/Cocoa: file system sandbox blocked stat()
  # /nix/store/in41dz8byyyz4c0w132l7mqi43liv4yr-stdenv-darwin/setup: line 1310:  2231 Abort trap: 6           signal-cli --version
  doInstallCheck = stdenvNoCC.hostPlatform.isLinux;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    homepage = "https://github.com/AsamK/signal-cli";
    description = "Command-line and dbus interface for communicating with the Signal messaging service";
    mainProgram = "signal-cli";
    changelog = "https://github.com/AsamK/signal-cli/blob/v${finalAttrs.version}/CHANGELOG.md";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ivan ];
    platforms = lib.platforms.all;
  };
})
