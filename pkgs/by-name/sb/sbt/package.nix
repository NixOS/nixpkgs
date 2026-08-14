{
  lib,
  stdenv,
  fetchurl,
  jre,
  autoPatchelfHook,
  makeWrapper,
  zlib,
  ncurses,
  callPackage,
  runCommand,
}:

let
  # sbt itself is a shell script plus a jar and runs wherever the jre does; only
  # the optional native thin client is architecture-specific, and upstream ships
  # one for these systems alone.
  nativeClients = {
    aarch64-darwin = "sbtn-universal-apple-darwin";
    aarch64-linux = "sbtn-aarch64-pc-linux";
    x86_64-linux = "sbtn-x86_64-pc-linux";
  };

  nativeClient = nativeClients.${stdenv.hostPlatform.system} or null;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sbt";
  version = "2.0.6";

  src = fetchurl {
    url = "https://github.com/sbt/sbt/releases/download/v${finalAttrs.version}/sbt-${finalAttrs.version}.tgz";
    hash = "sha256-YM54pQtya1szKlJ342PWfAKPFqOhUVf3ikFsCylJvG0=";
  };

  # This is baked into conf/sbtopts below, so it is the JDK every sbt
  # invocation runs on, and sbt 2 refuses to start on anything older.
  postPatch =
    assert lib.assertMsg (lib.versionAtLeast jre.version "17.0.0") ''
      sbt requires Java 17 or newer, but ${jre.name} is ${jre.version}
    '';
    ''
      echo -java-home ${jre.home} >>conf/sbtopts
    '';

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc # libstdc++.so.6
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/sbt $out/bin
    cp -ra . $out/share/sbt

    # The native client shells out to infocmp; a wrapper is what actually puts
    # it on the PATH of a running sbt.
    makeWrapper $out/share/sbt/bin/sbt $out/bin/sbt \
      --prefix PATH : ${lib.makeBinPath [ ncurses ]}
  ''
  + lib.optionalString (nativeClient != null) ''
    makeWrapper $out/share/sbt/bin/${nativeClient} $out/bin/sbtn \
      --prefix PATH : ${lib.makeBinPath [ ncurses ]}
  ''
  + ''
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    # --allow-empty because there is no project here, and the runner reports its
    # own version without reaching the network.
    export HOME="$TMPDIR"
    $out/bin/sbt --version --allow-empty | grep -q "${finalAttrs.version}"

    runHook postInstallCheck
  '';

  passthru.updateScript = {
    command = lib.getExe (callPackage ./update.nix { });
    supportedFeatures = [ "commit" ];
  };

  passthru.tests.version = runCommand "${finalAttrs.pname}-version" { } ''
    export HOME="$TMPDIR"
    ${lib.getExe finalAttrs.finalPackage} --version --allow-empty > version.txt
    grep -q 'sbt runner version: ${finalAttrs.version}' version.txt
    touch $out
  '';

  meta = {
    homepage = "https://www.scala-sbt.org/";
    changelog = "https://github.com/sbt/sbt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    description = "Build tool for Scala, Java and more";
    maintainers = with lib.maintainers; [
      agilesteel
      kashw2
    ];
    # sbt is a launcher script and a jar, so it runs wherever the jre does
    platforms = jre.meta.platforms;
    mainProgram = "sbt";
  };
})
