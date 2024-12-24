{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  jdk17_headless,
  jre17_minimal,
  gradle_7,
  bash,
  coreutils,
  substituteAll,
  nixosTests,
  fetchpatch,
  writeText,
}:

let
  gradle = gradle_7;
  jdk = jdk17_headless;
  # Reduce closure size
  jre = jre17_minimal.override {
    modules = [
      "java.base"
      "java.logging"
      "java.naming"
      "java.sql"
      "java.desktop"
      "java.management"
    ];
    jdk = jdk17_headless;
  };

  version = "01497";

  freenet_ext = fetchurl {
    url = "https://github.com/freenet/fred/releases/download/build01495/freenet-ext.jar";
    hash = "sha256-MvKz1r7t9UE36i+aPr72dmbXafCWawjNF/19tZuk158=";
  };

  seednodes = fetchFromGitHub {
    name = "freenet-seednodes";
    owner = "hyphanet";
    repo = "seedrefs";
    rev = "9df1bf93ab64aba634bdfc5f4d0e960571ce4ba5";
    hash = "sha256-nvwJvKw5IPhItPe4k/jnOGaa8H4DtOi8XxKFOKFMAuY=";
    postFetch = ''
      cat $out/* > $out/seednodes.fref
    '';
  };

  patches = [
    # gradle 7 support
    # https://github.com/freenet/fred/pull/827
    (fetchpatch {
      url = "https://github.com/freenet/fred/commit/8991303493f2c0d9933f645337f0a7a5a979e70a.patch";
      hash = "sha256-T1zymxRTADVhhwp2TyB+BC/J4gZsT/CUuMrT4COlpTY=";
    })
  ];

in
stdenv.mkDerivation rec {
  pname = "freenet";
  inherit version patches;

  src = fetchFromGitHub {
    owner = "freenet";
    repo = "fred";
    rev = "refs/tags/build${version}";
    hash = "sha256-pywNPekofF/QotNVF28McojqK7c1Zzucds5rWV0R7BQ=";
  };

  postPatch = ''
    rm gradle/verification-{keyring.keys,metadata.xml}
  '';

  nativeBuildInputs = [
    gradle
    jdk
  ];

  wrapper = substituteAll {
    src = ./freenetWrapper;
    inherit
      bash
      coreutils
      jre
      seednodes
      ;
  };

  mitmCache = gradle.fetchDeps {
    inherit pname;
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
    install -Dm755 ${wrapper} $out/bin/freenet
    export CLASSPATH="$(find ${mitmCache} -name "*.jar"| sort | grep -v bcprov-jdk15on-1.48.jar|tr $'\n' :):$out/share/freenet/freenet-ext.jar:$out/share/freenet/freenet.jar"
    substituteInPlace $out/bin/freenet \
      --subst-var-by CLASSPATH "$CLASSPATH"

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) freenet;
  };

  meta = {
    description = "Decentralised and censorship-resistant network";
    homepage = "https://freenetproject.org/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ nagy ];
    platforms = with lib.platforms; linux;
    changelog = "https://github.com/freenet/fred/blob/build${version}/NEWS.md";
  };
}
