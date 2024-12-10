{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  jdk,
  jre,
  gradle,
  bash,
  coreutils,
  substituteAll,
  nixosTests,
  perl,
  fetchpatch,
  writeText,
}:

let
  version = "01497";

  freenet_ext = fetchurl {
    url = "https://github.com/freenet/fred/releases/download/build01495/freenet-ext.jar";
    sha256 = "sha256-MvKz1r7t9UE36i+aPr72dmbXafCWawjNF/19tZuk158=";
  };

  seednodes = fetchurl {
    url = "https://downloads.freenetproject.org/alpha/opennet/seednodes.fref";
    sha256 = "08awwr8n80b4cdzzb3y8hf2fzkr1f2ly4nlq779d6pvi5jymqdvv";
  };

  patches = [
    # gradle 7 support
    # https://github.com/freenet/fred/pull/827
    (fetchpatch {
      url = "https://github.com/freenet/fred/commit/8991303493f2c0d9933f645337f0a7a5a979e70a.patch";
      sha256 = "sha256-T1zymxRTADVhhwp2TyB+BC/J4gZsT/CUuMrT4COlpTY=";
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

  # https://github.com/freenet/fred/blob/next/build-offline.sh
  # fake build to pre-download deps into fixed-output derivation
  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit src version patches;

    nativeBuildInputs = [
      gradle
      perl
    ];
    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      gradle --no-daemon build
    '';
    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/''${\($5 =~ s/okio-jvm/okio/r)}" #e' \
        | sh
    '';
    # Don't move info to share/
    forceShare = [ "dummy" ];
    outputHashMode = "recursive";
    # Downloaded jars differ by platform
    outputHash = "sha256-CZf5M3lI7Lz9Pl8U/lNoQ6V6Jxbmkxau8L273XFFS2E=";
    outputHashAlgo = "sha256";
  };

  # Point to our local deps repo
  gradleInit = writeText "init.gradle" ''
    gradle.projectsLoaded {
      rootProject.allprojects {
        buildscript {
          repositories {
            clear()
            maven { url '${deps}/'; metadataSources {mavenPom(); artifact()} }
          }
        }
        repositories {
          clear()
          maven { url '${deps}/'; metadataSources {mavenPom(); artifact()} }
        }
      }
    }

    settingsEvaluated { settings ->
      settings.pluginManagement {
        repositories {
          maven { url '${deps}/'; metadataSources {mavenPom(); artifact()} }
        }
      }
    }
  '';

  buildPhase = ''
    gradle jar -Dorg.gradle.java.home=${jdk} --offline --no-daemon --info --init-script $gradleInit
  '';

  installPhase = ''
    runHook preInstall
    install -Dm444 build/libs/freenet.jar $out/share/freenet/freenet.jar
    ln -s ${freenet_ext} $out/share/freenet/freenet-ext.jar
    mkdir -p $out/bin
    install -Dm555 ${wrapper} $out/bin/freenet
    substituteInPlace $out/bin/freenet \
      --subst-var-by outFreenet $out
    ln -s ${deps} $out/deps
    runHook postInstall
  '';

  passthru.tests = { inherit (nixosTests) freenet; };

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
