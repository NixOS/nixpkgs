{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  bash,
  coreutils,
  gnused,
  jre_headless,
  versionCheckHook,
}:

let
  info = lib.splitString "-" stdenv.hostPlatform.system;
  arch = lib.elemAt info 0;
  plat = lib.elemAt info 1;
  hashes = {
    x86_64-linux = "sha512-653G62HoctxeUzp/JKh60x4E386h5F4EubsglKOOZraQ2doKYLaWh5+A0tDJRsaQg5Gt3V/9eyACyso5UoxkPQ==";
    aarch64-linux = "sha512-ACTzgaQQcwRBb2OHRRhMJxV8tqZa6KRrFd7N/DVI2o2zRihwxPzkLQiidMgwXMHfkGfGhdgQ8istjNEAkdOuYw==";
    aarch64-darwin = "sha512-4IIijDdcZ76LE+mlBpUCwNeY6IrL5pVFEKGGsADepwaii1mX+sjb/5WrzXmfEu7wU1kljn8lLp3nUcK69JDLLA==";
  };
in
stdenv.mkDerivation (finalAttrs: {
  version = "8.19.25";
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
  ];

  buildInputs = [
    bash
    jre_headless
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r {Gemfile*,modules,vendor,lib,bin,config,data,logstash-core,logstash-core-plugin-api,x-pack} $out

    patchShebangs --host $out/bin/logstash $out/bin/logstash-plugin

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
