{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  bash,
  coreutils,
  gnused,
  nixosTests,
  jre_headless,
  versionCheckHook,
}:

let
  info = lib.splitString "-" stdenv.hostPlatform.system;
  arch = lib.elemAt info 0;
  plat = lib.elemAt info 1;
  hashes = {
    x86_64-linux = "sha512-nnIP21aLH8pCqa5iw3Mi3kJC7XHUvuF2vPfyom4+zROojTr+CIrkjjV+MJj33uI/Dqb0ie9CCMMXDGbM4EH+tA==";
    aarch64-linux = "sha512-rWfCtXqj6kS6MG8Jnv23GBDJdDKFOFZTflmYw4ST0u8d1+2jnJAMgoO+rfv7HXA75+qB0dZiwfmdXwSg2Q1CPQ==";
    x86_64-darwin = "sha512-gQdmjej9tFY04yEBSZj4CW7fMHm1MX+nRtU+aDWAYTesqJbwxBY1fbpteBCXJYiKsH4b9gprTqlhO0rOWx18GA==";
    aarch64-darwin = "sha512-AzVqtdncJtvYlAAZITX1wKpqsxfq2/rlPEZ8UqAwcRHlFWrgERI06kvUuYEkytTEEvuoQJIgpV0c9Z/RYfSIsg==";
  };
in
stdenv.mkDerivation (finalAttrs: {
  version = "8.19.16";
  pname = "logstash";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/logstash/${finalAttrs.pname}-${finalAttrs.version}-${plat}-${arch}.tar.gz";
    hash = hashes.${stdenv.hostPlatform.system} or (throw "Unknown architecture");
  };

  dontBuild = true;
  dontPatchELF = true;
  dontStrip = true;
  dontPatchShebangs = true;

  nativeBuildInputs = [
    makeWrapper
    bash
  ];

  buildInputs = [
    jre_headless
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r {Gemfile*,modules,vendor,lib,bin,config,data,logstash-core,logstash-core-plugin-api,x-pack} $out

    sed -i "1s|#!/bin/bash|#!${bash}/bin/bash|" $out/bin/logstash $out/bin/logstash-plugin

    wrapProgram $out/bin/logstash \
       --prefix PATH : "${
         lib.makeBinPath [
           coreutils
           gnused
         ]
       }" \
       --set LS_JAVA_HOME "${jre_headless}"

    wrapProgram $out/bin/logstash-plugin \
       --prefix PATH : "${
         lib.makeBinPath [
           coreutils
           gnused
         ]
       }" \
       --set LS_JAVA_HOME "${jre_headless}"
    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    tests = {
      elk = nixosTests.elk.ELK-8;
    };
  };

  meta = {
    description = "Data pipeline that helps you process logs and other event data from a variety of systems";
    homepage = "https://www.elastic.co/products/logstash";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # source bundles dependencies as jars
      binaryNativeCode # bundled jruby includes native code
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
      basvandijk
    ];
    mainProgram = "logstash";
  };
})
