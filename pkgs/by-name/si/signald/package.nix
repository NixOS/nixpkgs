{
  lib,
  stdenv,
  fetchFromGitLab,
  jdk17_headless,
  coreutils,
  findutils,
  gnused,
  gradle_8,
  git,
  makeWrapper,
  jre_minimal,
}:

let
  pname = "signald";
  version = "0.23.2";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = version;
    hash = "sha256-EofgwZSDp2ZFhlKL2tHfzMr3EsidzuY4pkRZrV2+1bA=";
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

  # "Deprecated Gradle features were used in this build, making it incompatible with Gradle 9.0."
  gradle = gradle_8;

in
stdenv.mkDerivation {
  inherit pname src version;

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleFlags = [ "-Dorg.gradle.java.home=${jdk17_headless}" ];

  gradleBuildTask = "distTar";

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    tar xvf ./build/distributions/signald.tar --strip-components=1 --directory $out/
    wrapProgram $out/bin/signald \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          findutils
          gnused
        ]
      } \
      --set JAVA_HOME "${jre'}"

    runHook postInstall
  '';

  nativeBuildInputs = [
    git
    gradle
    makeWrapper
  ];

  doCheck = true;

  gradleUpdateScript = ''
    runHook preBuild

    SIGNALD_TARGET=x86_64-unknown-linux-gnu gradle nixDownloadDeps
    SIGNALD_TARGET=aarch64-unknown-linux-gnu gradle nixDownloadDeps
    SIGNALD_TARGET=x86_64-apple-darwin gradle nixDownloadDeps
    SIGNALD_TARGET=aarch64-apple-darwin gradle nixDownloadDeps
  '';

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
      binaryBytecode # deps
    ];
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
