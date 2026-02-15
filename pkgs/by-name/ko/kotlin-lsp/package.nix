{
  lib,
  stdenv,
  fetchzip,
  openjdk21,
  makeWrapper,
  autoPatchelfHook,
}:

let
  version = "261.13587.0";

  sources = {
    "x86_64-linux" = {
      platform = "linux-x64";
      hash = "sha256-EweSqy30NJuxvlJup78O+e+JOkzvUdb6DshqAy1j9jE=";
    };
    "aarch64-linux" = {
      platform = "linux-aarch64";
      hash = "sha256-MhHEYHBctaDH9JVkN/guDCG1if9Bip1aP3n+JkvHCvA=";
    };
    "x86_64-darwin" = {
      platform = "mac-x64";
      hash = "sha256-zMuUcahT1IiCT1NTrMCIzUNM0U6U3zaBkJtbGrzF7I8=";
    };
    "aarch64-darwin" = {
      platform = "mac-aarch64";
      hash = "sha256-zwlzVt3KYN0OXKr6sI9XSijXSbTImomSTGRGa+3zCK8=";
    };
  };

  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "kotlin-lsp";
  inherit version;

  src = fetchzip {
    url = "https://download-cdn.jetbrains.com/kotlin-lsp/${version}/kotlin-lsp-${version}-${source.platform}.zip";
    inherit (source) hash;
    stripRoot = false;
  };

  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/kotlin-lsp
    cp -r lib/* $out/lib/kotlin-lsp/
    cp -r native $out/lib/kotlin-lsp/

    mkdir -p $out/bin
    makeWrapper ${openjdk21}/bin/java $out/bin/kotlin-lsp \
      --add-flags "--add-opens java.base/java.io=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/java.lang=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/java.lang.ref=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/java.lang.reflect=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/java.net=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/java.nio=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/java.nio.charset=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/java.text=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/java.time=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/java.util=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/java.util.concurrent=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/java.util.concurrent.atomic=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/java.util.concurrent.locks=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/jdk.internal.vm=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/sun.net.dns=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/sun.nio.ch=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/sun.nio.fs=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/sun.security.ssl=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/sun.security.util=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/com.apple.eawt=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/com.apple.eawt.event=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/com.apple.laf=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/com.sun.java.swing=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/com.sun.java.swing.plaf.gtk=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/java.awt=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/java.awt.dnd.peer=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/java.awt.event=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/java.awt.font=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/java.awt.image=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/java.awt.peer=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/javax.swing=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/javax.swing.plaf.basic=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/javax.swing.text=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/javax.swing.text.html=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/sun.awt=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/sun.awt.X11=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/sun.awt.datatransfer=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/sun.awt.image=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/sun.awt.windows=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/sun.font=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/sun.java2d=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/sun.lwawt=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/sun.lwawt.macosx=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/sun.swing=ALL-UNNAMED" \
      --add-flags "--add-opens java.management/sun.management=ALL-UNNAMED" \
      --add-flags "--add-opens jdk.attach/sun.tools.attach=ALL-UNNAMED" \
      --add-flags "--add-opens jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED" \
      --add-flags "--add-opens jdk.internal.jvmstat/sun.jvmstat.monitor=ALL-UNNAMED" \
      --add-flags "--add-opens jdk.jdi/com.sun.tools.jdi=ALL-UNNAMED" \
      --add-flags "--enable-native-access=ALL-UNNAMED" \
      --add-flags "-Djdk.lang.Process.launchMechanism=FORK" \
      --add-flags "-Djava.awt.headless=true" \
      --add-flags "-Djava.library.path='$out/lib/kotlin-lsp/native'" \
      --add-flags "-cp '$out/lib/kotlin-lsp/*'" \
      --add-flags "com.jetbrains.ls.kotlinLsp.KotlinLspServerKt"

    runHook postInstall
  '';

  meta = {
    description = "Official Kotlin Language Server from JetBrains (pre-alpha)";
    homepage = "https://github.com/Kotlin/kotlin-lsp";
    license = lib.licenses.asl20;
    mainProgram = "kotlin-lsp";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    platforms = builtins.attrNames sources;
    maintainers = with lib.maintainers; [ imsugeno ];
  };
}
