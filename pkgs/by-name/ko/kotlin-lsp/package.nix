{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  darwin,
  fixDarwinDylibNames,
  unar,
  versionCheckHook,
  zlib,
}:

let
  system = stdenv.hostPlatform.system;

  archiveFile =
    version:
    {
      "x86_64-linux" = "kotlin-server-${version}.tar.gz";
      "aarch64-linux" = "kotlin-server-${version}-aarch64.tar.gz";
      "x86_64-darwin" = "kotlin-server-${version}.sit";
      "aarch64-darwin" = "kotlin-server-${version}-aarch64.sit";
    }
    .${system} or (throw "kotlin-lsp does not support ${system}");
  archiveHash =
    {
      "x86_64-linux" = "sha256-RpcREMm4ozYM4/31Q3Rn9MRH2tN61z2/gdZK9neeQQU=";
      "aarch64-linux" = "sha256-YlhwrgkcbQ3uJVFNVFxwim6lDXy7UVSq8aqRI8z/M4s=";
      "x86_64-darwin" = "sha256-bwbv56EPlLnIoCjE7+tsfhdp9HoB7ft0RQrPMKtWZeQ=";
      "aarch64-darwin" = "sha256-G3RXQ84irZJoGhvDsQRoA+lCpuHzbgT7ha6aQDNKLx4=";
    }
    .${system} or (throw "kotlin-lsp does not support ${system}");
in

stdenv.mkDerivation (finalAttrs: {
  pname = "kotlin-lsp";
  version = "262.4739.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://download-cdn.jetbrains.com/kotlin-lsp/${finalAttrs.version}/${archiveFile finalAttrs.version}";
    hash = archiveHash;
  };

  # Add support for .sit archive using unar
  preUnpack = lib.optionalString stdenv.isDarwin ''
    _tryUnar() {
      if ! [[ "$curSrc" =~ \.sit$ ]]; then return 1; fi
      ${lib.getExe unar} "$curSrc"
    }
    unpackCmdHooks+=(_tryUnar)
  '';

  dontConfigure = true;
  dontBuild = true;

  # Stripping breaks the binary on Darwin (code signing issues)
  dontStrip = stdenv.isDarwin;

  # (on Linux only) X11/Wayland/sound/font libs are GUI-only backends in the bundled JBR;
  # the LSP server itself runs headless so these are safe to ignore.
  autoPatchelfIgnoreMissingDeps = [
    "libasound.so.2"
    "libc.musl-x86_64.so.1"
    "libfreetype.so.6"
    "libwayland-client.so.0"
    "libwayland-cursor.so.0"
    "libX11.so.6"
    "libXext.so.6"
    "libXi.so.6"
    "libXrender.so.1"
    "libXtst.so.6"
    "libxkbcommon.so.0"
  ];
  nativeBuildInputs = (
    lib.optionals stdenv.isLinux [ autoPatchelfHook ]
    ++ lib.optionals stdenv.isDarwin [
      fixDarwinDylibNames
      unar
      darwin.autoSignDarwinBinariesHook
    ]
  );

  buildInputs = [
    # for native JNI libs (rocksdbjni, filewatcher),
    stdenv.cc.cc.lib # libgcc_s.so.1, libstdc++.so.6
    # for the bundled JBR (libjli, libzip, libinstrument, etc.)
    zlib
  ];

  installPhase = ''
    runHook preInstall

    # Install the vendored JBR (JetBrains Runtime) tree under $out/share/kotlin-lsp.
    # The `product-info.json` must sit in a parent directory of `intellij-server` binary.
    mkdir -p $out/share/kotlin-lsp
    cp -r bin jbr lib modules plugins product-info.json build.txt $out/share/kotlin-lsp/

    mkdir -p $out/bin
    ln -s ../share/kotlin-lsp/bin/intellij-server $out/bin/kotlin-lsp

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Official Kotlin LSP, by JetBrains";
    longDescription = ''
      Pre-alpha official Kotlin support for editors using the Language Server Protocol.
      The server is based on IntelliJ IDEA and the IntelliJ IDEA Kotlin Plugin.
      Supports JVM Kotlin Gradle projects out of the box, with Maven and other build
      systems also supported.
    '';
    homepage = "https://github.com/Kotlin/kotlin-lsp";
    changelog = "https://github.com/Kotlin/kotlin-lsp/releases/tag/kotlin-lsp%2Fv${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      bew
      eveeifyeve
    ];
    license = with lib.licenses; [
      asl20
      # NOTE: @2026-04 the LSP source code is not public
      unfreeRedistributable
    ];
    platforms = lib.platforms.darwin ++ [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = [
      lib.sourceTypes.binaryNativeCode
      lib.sourceTypes.binaryBytecode
    ];
    mainProgram = "kotlin-lsp";
  };
})
