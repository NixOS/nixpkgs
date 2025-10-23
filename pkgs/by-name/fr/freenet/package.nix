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
  gradle = gradle_8;
  jdk = jdk_headless;

  freenet_ext = fetchurl {
    url = "https://github.com/freenet/fred/releases/download/build01495/freenet-ext.jar";
    hash = "sha256-MvKz1r7t9UE36i+aPr72dmbXafCWawjNF/19tZuk158=";
  };

  seednodes = fetchFromGitHub {
    name = "freenet-seednodes";
    owner = "hyphanet";
    repo = "seedrefs";
    rev = "8e8b3574b63e649e03f67d23d3dfa461b7a0ba4a";
    hash = "sha256-OCXBfhgheOH8XZjUhvJpNQ1I73rCwUfgyl/xkZt3JeM=";
    postFetch = ''
      cat $out/* > $out/seednodes.fref
    '';
  };

in
stdenv.mkDerivation rec {
  pname = "freenet";
  version = "01503";

  src = fetchFromGitHub {
    owner = "freenet";
    repo = "fred";
    tag = "build${version}";
    hash = "sha256-SjHQssCwPjSoaxsLmaov4bRoz+6XSlHfiOoxWxlRn60=";
  };

  nativeBuildInputs = [
    gradle
    jdk
  ];

  wrapper = replaceVars ./freenetWrapper {
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
    mainProgram = "freenet";
  };
}
