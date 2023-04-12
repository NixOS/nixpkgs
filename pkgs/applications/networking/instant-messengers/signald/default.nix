{ lib, stdenv, fetchurl, fetchFromGitLab, jdk17_headless, coreutils, gradle, git, perl
, makeWrapper, fetchpatch, substituteAll, jre_minimal
}:

# NOTE: when updating the package, please check if some of the hacks in `deps.installPhase`
# can be removed again!

let
  pname = "signald";
  version = "0.23.2";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-EofgwZSDp2ZFhlKL2tHfzMr3EsidzuY4pkRZrV2+1bA=";
  };

  jre' = jre_minimal.override {
    jdk = jdk17_headless;
    # from https://gitlab.com/signald/signald/-/blob/0.23.0/build.gradle#L173
    modules = [
      "java.base"
      "java.management"
      "java.naming"
      "java.sql"
      "java.xml"
      "jdk.crypto.ec"
      "jdk.httpserver"

      # for java/beans/PropertyChangeEvent
      "java.desktop"
      # for sun/misc/Unsafe
      "jdk.unsupported"
    ];
  };

  # fake build to pre-download deps into fixed-output derivation
  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit src version;
    nativeBuildInputs = [ gradle perl ];
    patches = [ ./0001-Fetch-buildconfig-during-gradle-build-inside-Nix-FOD.patch ];
    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      gradle --no-daemon build
    '';
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh -x

      # WARNING: don't try this at home and wear safety-goggles while working with this!
      # We patch around in the dependency tree to resolve some spurious dependency resolution errors.
      # Whenever this package gets updated, please check if some of these hacks are obsolete!

      # Mimic existence of okio-3.2.0.jar. Originally known as okio-jvm-3.2.0 (and renamed),
      # but gradle doesn't detect such renames, only fetches the latter and then fails
      # in `signald.buildPhase` because it cannot find `okio-3.2.0.jar`.
      pushd $out/com/squareup/okio/okio/3.2.0 &>/dev/null
        cp -v ../../okio-jvm/3.2.0/okio-jvm-3.2.0.jar okio-3.2.0.jar
      popd &>/dev/null

      # For some reason gradle fetches 2.14.1 instead of 2.14.0 here even though 2.14.0 is required
      # according to `./gradlew -q dependencies`, so we pretend to have 2.14.0 available here.
      # According to the diff in https://github.com/FasterXML/jackson-dataformats-text/compare/jackson-dataformats-text-2.14.0...jackson-dataformats-text-2.14.1
      # the only relevant change is in the code itself (and in the tests/docs), so this seems
      # binary-compatible.
      cp -v \
        $out/com/fasterxml/jackson/dataformat/jackson-dataformat-toml/2.14.1/jackson-dataformat-toml-2.14.1.jar \
        $out/com/fasterxml/jackson/dataformat/jackson-dataformat-toml/2.14.0/jackson-dataformat-toml-2.14.0.jar
    '';
    # Don't move info to share/
    forceShare = [ "dummy" ];
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    # Downloaded jars differ by platform
    outputHash = {
      x86_64-linux = "sha256-9DHykkvazVBN2kfw1Pbejizk/R18v5w8lRBHZ4aXL5Q=";
      aarch64-linux = "sha256-RgAiRbUojBc+9RN/HpAzzpTjkjZ6q+jebDsqvah5XBw=";
    }.${stdenv.system} or (throw "Unsupported platform");
  };

in stdenv.mkDerivation {
  inherit pname src version;

  patches = [
    (substituteAll {
      src = ./0002-buildconfig-local-deps-fixes.patch;
      inherit deps;
    })
  ];

  passthru = {
    # Mostly for debugging purposes.
    inherit deps;
  };

  buildPhase = ''
    runHook preBuild

    export GRADLE_USER_HOME=$(mktemp -d)

    gradle --offline --no-daemon distTar

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    tar xvf ./build/distributions/signald.tar --strip-components=1 --directory $out/
    wrapProgram $out/bin/signald \
      --prefix PATH : ${lib.makeBinPath [ coreutils ]} \
      --set JAVA_HOME "${jre'}"

    runHook postInstall
  '';

  nativeBuildInputs = [ git gradle makeWrapper ];

  doCheck = true;

  meta = with lib; {
    description = "Unofficial daemon for interacting with Signal";
    longDescription = ''
      Signald is a daemon that facilitates communication over Signal.  It is
      unofficial, unapproved, and not nearly as secure as the real Signal
      clients.
    '';
    homepage = "https://signald.org";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # deps
    ];
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ expipiplus1 ma27 ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
