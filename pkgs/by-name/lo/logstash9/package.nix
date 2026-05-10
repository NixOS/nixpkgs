{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  bash,
  nixosTests,
  jre_headless,
}:

let
  info = lib.splitString "-" stdenv.hostPlatform.system;
  arch = lib.elemAt info 0;
  plat = lib.elemAt info 1;
  hashes = {
    x86_64-linux = "sha512-8UquZIbgIjQjmZ5QWBpYGqZz1dUIIhF7g7JeU+1YYwP5w2ELEIxbOFoBtHFCcGvrH/85avUFOasRHXTuUbZXuw==";
    aarch64-linux = "sha512-XjGPGiyQjmN9l1MCxSC21t7dlwIjb5tc7C0nsI3g6febwfl1JX3beKOm7y3SjGFawsNL5Ik2l/28jO2L+LjLbA==";
    x86_64-darwin = "sha512-INPSNwXSL8r0BP8hh2fj3ReysAWdOSH3Hmk3Q40ZaONLykY2lv+qnHS21PCNdffJMcDyIrlTkNSJCdF3Chx4sw==";
    aarch64-darwin = "sha512-OqEKV4vQR5qXqKMM3pOlkOTEisAt9KidH7pJlN+TIKZ1Qhb/pqACGMCEbQ1164v6UMHNkyRRtAnrAc6rMfrSVw==";
  };
in
stdenv.mkDerivation (finalAttrs: {
  version = "9.4.0";
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
    cp -r {vendor,lib,bin,config,logstash-core,logstash-core-plugin-api,x-pack} $out

    sed -i "1s|#!/bin/bash|#!${bash}/bin/bash|" $out/bin/logstash $out/bin/logstash-plugin

    wrapProgram $out/bin/logstash \
       --set LS_JAVA_HOME "${jre_headless}"

    wrapProgram $out/bin/logstash-plugin \
       --set LS_JAVA_HOME "${jre_headless}"
    runHook postInstall
  '';

  passthru = {
    tests = {
      elk = nixosTests.elk.ELK-9;
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
  };
})
