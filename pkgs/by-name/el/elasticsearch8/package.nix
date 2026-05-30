{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  bash,
  util-linuxMinimal,
  gnugrep,
  coreutils,
  autoPatchelfHook,
  zlib,
  versionCheckHook,
}:

let
  info = lib.splitString "-" stdenv.hostPlatform.system;
  arch = lib.elemAt info 0;
  plat = lib.elemAt info 1;
  hashes = {
    x86_64-linux = "sha512-b/zOj+RtJbA1s5ECYxCX8qMR5H1AaZGTKyUk09S7MJx0CopNMRNZCfyC+Mfkl8PCxUTM9Y6VdeIAxqAYPtisZg==";
    aarch64-linux = "sha512-2Jxi5FdstVf3gLiPmwdUPq0zxRK+Zjs0qj/FkH6HIJp9jwvs7dGBhimKZKEwgUiD+xeSLogGhFjYXfADHSM6hw==";
    x86_64-darwin = "sha512-/fexaxu/PfsI2tyUTE6o0SOU/5b1bC2RDbxwk/pbSfVwI9K8XWwK3mDwifgYNFC27fwN0oW3XDdCPVO7E+oeeg==";
    aarch64-darwin = "sha512-7iwjKUk51HXejQi6kBKqHQAAntg8uHWPb5fjm2c3heAd8rEZcpy1Jmt4kUuvSXLFPOsfXB+c5TFAuHbqsWMvmg==";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "elasticsearch";
  version = "8.19.16";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/elasticsearch/${finalAttrs.pname}-${finalAttrs.version}-${plat}-${arch}.tar.gz";
    hash = hashes.${stdenv.hostPlatform.system} or (throw "Unknown architecture");
  };

  nativeBuildInputs = [
    makeWrapper
    bash
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) autoPatchelfHook;

  buildInputs = [
    util-linuxMinimal
    zlib
  ];

  runtimeDependencies = [ zlib ];

  # The bundled JDK ships AWT/sound libraries that link against X11,
  # freetype, and alsa. Elasticsearch runs headlessly and never loads
  # these, so leave their dependencies unresolved rather than dragging
  # a graphical stack into the closure.
  autoPatchelfIgnoreMissingDeps = [
    "libX11.so.6"
    "libXext.so.6"
    "libXi.so.6"
    "libXrender.so.1"
    "libXtst.so.6"
    "libasound.so.2"
    "libfreetype.so.6"
  ];

  installPhase = ''
            mkdir -p $out
            # Ship the bundled JDK: Elasticsearch's entitlements agent is
            # bytecode-coupled to a specific JDK version, so substituting a
            # different JDK (e.g. via `ES_JAVA_HOME`) triggers self-denied
            # `checkChangeJVMGlobalState` failures at startup.
            # `autoPatchelfHook` fixes the bundled `jdk/` ELF binaries.
            cp -R bin config jdk lib modules plugins $out

            chmod +x $out/bin/*
            find $out/bin -maxdepth 1 -type f -exec sed -i "1s|#!/bin/bash|#!${bash}/bin/bash|" {} +

            substituteInPlace $out/bin/elasticsearch \
              --replace 'bin/elasticsearch-keystore' "$out/bin/elasticsearch-keystore"

            substituteInPlace $out/bin/elasticsearch-env \
              --replace 'ES_HOME=`dirname "$SCRIPT"`' \
              'if [ -z "$ES_HOME" ]; then
        ES_HOME=`dirname "$SCRIPT"`' \
              --replace 'ES_HOME=`dirname "$ES_HOME"`

    ' \
              'ES_HOME=`dirname "$ES_HOME"`
        fi
    '

            # The bundled JDK lives at $out/jdk. The launcher would normally
            # resolve `$ES_HOME/jdk/bin/java`, but the NixOS service overrides
            # `ES_HOME` to the data dir, so pin `ES_JAVA_HOME` to the store
            # path instead. Users can still override by exporting it.
            substituteInPlace $out/bin/elasticsearch-env \
              --replace '# now set the path to java' \
              'if [ -z "$ES_JAVA_HOME" ]; then ES_JAVA_HOME="'"$out"'/jdk"; fi
        # now set the path to java'

            # Only the main launcher is exec'd directly and safe to wrap.
            wrapProgram $out/bin/elasticsearch \
              --prefix PATH : "${
                lib.makeBinPath [
                  util-linuxMinimal
                  coreutils
                  gnugrep
                ]
              }"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Open Source, Distributed, RESTful Search Engine";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license =
      with lib.licenses;
      OR [
        agpl3Only
        elastic20
        sspl
      ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      kiara
      basvandijk
    ];
    mainProgram = "elasticsearch";
  };
})
