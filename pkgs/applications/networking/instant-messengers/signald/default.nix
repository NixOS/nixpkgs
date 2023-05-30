{ lib, stdenv, fetchFromGitLab, jdk17_headless, coreutils, gradle, git
, makeWrapper, jre_minimal
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
  info = {
    # lockfiles, hashes and targets differ per system
    # because of a native dependency on libsignal-service-java
    x86_64-linux = {
      SIGNALD_TARGET = "x86_64-unknown-linux-gnu";
      depsHash = "sha256-lOXh3Fk0/DGq8C6zFYmQgANW6x9OHwxErtozpnQ/81s=";
      lockfile = ./x86_64-linux/gradle.lockfile;
      buildscriptLockfile = ./x86_64-linux/buildscript-gradle.lockfile;
    };
    # targets supported by upstream
    # (see https://gitlab.com/signald/libraries/libsignal-service-java/-/packages)
    # aarch64-linux = {
    #   SIGNALD_TARGET = "aarch64-unknown-linux-gnu";
    # };
    # x86_64-darwin = {
    #   SIGNALD_TARGET = "x86_64-apple-darwin";
    # };
    # aarch64-darwin = {
    #   SIGNALD_TARGET = "aarch64-apple-darwin";
    # };
    # SIGNALD_TARGET = "arm-unknown-linux-gnueabi";
    # SIGNALD_TARGET = "armv7-unknown-linux-gnueabihf";
    # SIGNALD_TARGET = "arm-unknown-linux-gnueabihf";
    # SIGNALD_TARGET = "unknown-linux-musl";
  }.${stdenv.system} or (throw "Unsupported platform");
in gradle.buildPackage {
  inherit pname src version;
  VERSION = version;

  gradleOpts.buildSubcommand = "distTar";

  inherit (info) SIGNALD_TARGET;

  gradleOpts = {
    inherit (info) depsHash lockfile buildscriptLockfile;
  };

  # WARNING: don't try this at home and wear safety-goggles while working with this!
  # We patch around in the dependency tree to resolve some spurious dependency resolution errors.
  # Whenever this package gets updated, please check if some of these hacks are obsolete!

  # Mimic existence of okio-3.2.0.jar. Originally known as okio-jvm-3.2.0 (and renamed),
  # but gradle doesn't detect such renames, only fetches the latter and then fails
  # in `signald.buildPhase` because it cannot find `okio-3.2.0.jar`.
  gradleOpts.depsAttrs.postInstall = ''
    pushd $out/com/squareup/okio/okio/3.2.0 &>/dev/null
    cp -v ../../okio-jvm/3.2.0/okio-jvm-3.2.0.jar okio-3.2.0.jar
    popd &>/dev/null
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

  nativeBuildInputs = [ git makeWrapper ];

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
