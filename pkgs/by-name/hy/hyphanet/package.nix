{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  jdk_headless,
  jre,
  gradle_8,
  bash,
  coreutils,
  replaceVars,
  nixosTests,
  writeText,
}:

let
  version = "1506";
  gradle = gradle_8;
  jdk = jdk_headless;

  freenet_ext = fetchurl {
    url = "https://github.com/hyphanet/fred/releases/download/build01495/freenet-ext.jar";
    hash = "sha256-MvKz1r7t9UE36i+aPr72dmbXafCWawjNF/19tZuk158=";
  };

  seednodes = fetchFromGitHub {
    name = "hyphanet-seednodes";
    owner = "hyphanet";
    repo = "seedrefs";
    rev = "b34dbc4d021c58c4a108214a71a9e1ab986c4e14";
    hash = "sha256-c04gKNPZtiIdmKmPJ71iXIEXzOoBMw32I2rAsN1+a8Q=";
    postFetch = ''
      cat $out/* > $out/seednodes.fref
    '';
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hyphanet";
  version = "0.7.5.${version}";

  src = fetchFromGitHub {
    owner = "hyphanet";
    repo = "fred";
    tag = "build0${version}";
    hash = "sha256-MmI/e/Sh4WeSSw2//xpmJtF5/oC9+eauXnTMLuojb2A=";
  };

  nativeBuildInputs = [
    gradle
    jdk
  ];

  wrapper = replaceVars ./hyphanetWrapper {
    inherit
      bash
      coreutils
      jre
      seednodes
      ;
    # replaced in installPhase
    CLASSPATH = null;
  };

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  # using reproducible archives breaks the build
  gradleInitScript = writeText "empty-init-script.gradle" "";

  gradleFlags = [ "-Dorg.gradle.java.home=${jdk}" ];

  gradleBuildTask = "jar";

  installPhase = ''
    runHook preInstall

    install -Dm644 build/libs/freenet.jar $out/share/freenet/freenet.jar
    ln -s ${freenet_ext} $out/share/freenet/freenet-ext.jar
    mkdir -p $out/bin
    install -Dm755 ${finalAttrs.wrapper} $out/bin/freenet
    export CLASSPATH="$(find ${finalAttrs.mitmCache} -name "*.jar"| sort | grep -v bcprov-jdk15on-1.48.jar|tr $'\n' :):$out/share/freenet/freenet-ext.jar:$out/share/freenet/freenet.jar"
    substituteInPlace $out/bin/freenet \
      --subst-var-by CLASSPATH "$CLASSPATH"

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) hyphanet;
  };

  meta = {
    description = "Decentralised and censorship-resistant network";
    homepage = "https://www.hyphanet.org/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ nagy ];
    platforms = with lib.platforms; linux;
    changelog = "https://github.com/hyphanet/fred/blob/build${version}/NEWS.md";
    mainProgram = "freenet";
  };
})
