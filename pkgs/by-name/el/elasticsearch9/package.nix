{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  bash,
  jre_headless,
  util-linuxMinimal,
  gnugrep,
  coreutils,
  autoPatchelfHook,
  zlib,
}:

let
  info = lib.splitString "-" stdenv.hostPlatform.system;
  arch = lib.elemAt info 0;
  plat = lib.elemAt info 1;
  hashes = {
    x86_64-linux = "sha512-zK+WIkE01CNyBc2kFe2cBvhuhMvKeRCAFU+ieHl7jSQj+OWDkvRmGx0s9hTvMBMbjZFYQB0Gn9zrlLwTfBdNww==";
    aarch64-linux = "sha512-SefL+xmrhdTTsb+b5tm68WCk0LCDoPqq7HC/F6KHKfDyTRNVChc5F1tThCOxt0TDgy21w4J5iH04SzDM/Thx1w==";
    x86_64-darwin = "sha512-ZJu+vwAy9qKsPjaMtRHrcV16SagD0eIp/6voZpGGVaqPV8Mur/SxW0m4zLh6HaVEXppb48KOmKSVqQoxrASd3w==";
    aarch64-darwin = "sha512-o88Np9UKwLHYe6w86lPDkdB9CHB2yeR5axWiIQflScF29aEKavq7Zu8hyQB/cnlpOGWp4o9lISAhwMo6yRmrmg==";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "elasticsearch";
  version = "9.4.0";

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
    jre_headless
    util-linuxMinimal
    zlib
  ];

  runtimeDependencies = [ zlib ];

  installPhase = ''
            mkdir -p $out
            cp -R bin config lib modules plugins $out

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

            # All tool scripts source elasticsearch-env, which resolves the JDK.
            # Inject the Nix JDK there so every script gets it without wrapProgram.
            # Users can still override by setting ES_JAVA_HOME before invocation.
            substituteInPlace $out/bin/elasticsearch-env \
              --replace '# now set the path to java' \
              'if [ -z "$ES_JAVA_HOME" ]; then ES_JAVA_HOME="${jre_headless}"; fi
        # now set the path to java'

            # Only the main launcher is exec'd directly and safe to wrap.
            wrapProgram $out/bin/elasticsearch \
              --prefix PATH : "${
                lib.makeBinPath [
                  util-linuxMinimal
                  coreutils
                  gnugrep
                ]
              }" \
              --set ES_JAVA_HOME "${jre_headless}"
  '';

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
  };
})
