{ lib, stdenv, fetchurl, fetchFromGitHub, jdk, jre, gradle, bash, coreutils
, substituteAll, nixosTests, fetchpatch, writeText }:

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

in stdenv.mkDerivation rec {
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

  nativeBuildInputs = [ gradle jdk ];

  wrapper = substituteAll {
    src = ./freenetWrapper;
    inherit bash coreutils jre seednodes;
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
    install -Dm444 build/libs/freenet.jar $out/share/freenet/freenet.jar
    ln -s ${freenet_ext} $out/share/freenet/freenet-ext.jar
    mkdir -p $out/bin
    install -Dm555 ${wrapper} $out/bin/freenet
    substituteInPlace $out/bin/freenet \
      --subst-var-by outFreenet $out
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
