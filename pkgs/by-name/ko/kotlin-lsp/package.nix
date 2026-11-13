{
  autoPatchelfHook,
  fetchzip,
  jetbrains,
  lib,
  makeWrapper,
  nix-update-script,
  stdenv,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kotlin-lsp";
  version = "271.2085.0";
  src = fetchzip {
    url = "https://download.jetbrains.com/language-server/kotlin-server/${finalAttrs.version}/kotlin-server-${finalAttrs.version}.tar.gz";
    hash = "sha256-lB+KkyW8h0j4Xpi//+IVxJvdSu2XFRS2QOwGHfrRG58=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--url"
      "https://github.com/Kotlin/kotlin-lsp"
      "--version-regex"
      "kotlin-lsp/v(.*)"
    ];
  };

  dontBuild = true;
  __structuredAttrs = true;
  strictDeps = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/kotlin-lsp
    cp -r bin lib modules plugins product-info.json $out/lib/kotlin-lsp/
    ln -s ${jetbrains.jdk}/lib/openjdk $out/lib/kotlin-lsp/jbr
    makeWrapper $out/lib/kotlin-lsp/bin/intellij-server $out/bin/kotlin-lsp
    runHook postInstall
  '';

  meta = {
    description = "Official Language Server for Kotlin by JetBrains";
    longDescription = ''
      Language Server Protocol implementation for Kotlin, based on IntelliJ IDEA.
    '';
    maintainers = with lib.maintainers; [ terminalnode ];
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.asl20;
    sourceProvenance = [
      lib.sourceTypes.binaryNativeCode
      lib.sourceTypes.binaryBytecode
    ];
    homepage = "https://github.com/Kotlin/kotlin-lsp";
    mainProgram = "kotlin-lsp";
  };
})
