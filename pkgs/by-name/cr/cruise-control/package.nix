{
  fetchFromGitHub,
  lib,
  makeWrapper,
  nix-update-script,
  stdenv,

  bash,
  coreutils,
  gawk,
  gnugrep,
  gradle_8,
  jdk17,
  jdk17_headless,
  procps,
}:

let
  gradle = gradle_8.override { java = jdk17; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cruise-control";
  version = "2.5.146";

  src = fetchFromGitHub {
    owner = "cruise-control-for-kafka";
    repo = "cruise-control";
    tag = finalAttrs.version;
    hash = "sha256-Paamv/dEHpJdCjnEnOajH1IYxp8h1+P0juWgaafruh8=";
  };

  outputs = [
    "out"
    "lib"
  ];

  patches = [
    # The semantic-build-versioning plugin computes `project.version` from git
    # tags, which fails due to the missing `.git` directory. We pass the
    # version explicitly via the `-Pversion` gradle flag instead.
    ./remove-git-tag-based-versioning.patch
    ./start-script-store-classpath.patch
    ./start-script-jars-classpath.patch
    ./start-script-writable-log-dir.patch
    # The GC logging flags were removed in JDK 9; use unified logging.
    ./start-script-unified-gc-logging.patch
  ];

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  gradleFlags = [
    "-Pversion=${finalAttrs.version}"
    # Some test sources contain a stray U+2028 (LINE SEPARATOR) in their
    # license headers. Without a locale in the build sandbox, JDK <= 17
    # defaults to US-ASCII and javac fails with "unmappable character
    # (0xE2) for encoding US-ASCII". Force UTF-8 so the sources compile.
    "-Dfile.encoding=UTF-8"
  ];

  gradleBuildTask = "jar";
  gradleUpdateTask = finalAttrs.gradleBuildTask;

  installPhase = ''
    runHook preInstall

    install -Dm644 -t "$out"/share/cruise-control \
      cruise-control/build/libs/cruise-control-${finalAttrs.version}.jar \
      cruise-control/build/dependant-libs/*.jar
    cp -r config "$out"/

    install -Dm644 -t "$lib"/share/java \
      cruise-control-metrics-reporter/build/libs/cruise-control-metrics-reporter-${finalAttrs.version}.jar
    ln -sf "$lib"/share/java/cruise-control-metrics-reporter-${finalAttrs.version}.jar "$out"/share/cruise-control/

    install -Dm755 -t "$out"/bin kafka-cruise-control-start.sh kafka-cruise-control-stop.sh
    substituteInPlace "$out"/bin/kafka-cruise-control-start.sh --subst-var out

    for output in "''${outputs[@]}"; do
      install -Dm644 -t "$output"/share/licenses/cruise-control LICENSE NOTICE
    done

    runHook postInstall
  '';

  makeWrapperArgs = [
    "--set"
    "JAVA_HOME"
    jdk17_headless.home
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      coreutils
      gawk
      gnugrep
      procps
    ])
  ];

  postFixup = ''
    for p in "$out"/bin/*.sh; do
      wrapProgram "$p" "''${makeWrapperArgs[@]}"
    done
  '';

  # tests start embedded Kafka brokers and require networking
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/cruise-control-for-kafka/cruise-control/releases/tag/${finalAttrs.src.tag}";
    description = "Automated workload rebalancing and self-healing for Apache Kafka";
    homepage = "https://github.com/cruise-control-for-kafka/cruise-control";
    license = with lib.licenses; [
      asl20
      bsd2 # build.gradle notes the historical BSD-2-Clause license
    ];
    mainProgram = "kafka-cruise-control-start.sh";
    maintainers = with lib.maintainers; [
      despsyched
      de11n
      sinrohit-desco
    ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
  };
})
