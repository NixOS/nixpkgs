{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gradle_8,
  jre,
  dart-sass,
  libarchive,
  makeWrapper,
  tree,
}:

let
  gradle = gradle_8;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "quarkdown";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "iamgio";
    repo = "quarkdown";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rCHpsCjPJRAh4a6GSwLqTIhAShTMLdED2LeE+Jxd/1Y=";
  };

  postPatch = ''
    # Skip downloadSass from and "download" it ourselves
    # (Due to https://github.com/EtienneMiret/sass-gradle-plugin)
    SASS_INSTALL_DIR=".gradle/sass/quarkdown-html/${dart-sass.version}/dart-sass"
    mkdir -p "$SASS_INSTALL_DIR"
    ln -s ${lib.getExe dart-sass} "$SASS_INSTALL_DIR/sass"

    cat <<EOF >> quarkdown-html/build.gradle.kts

    sass {
      version = "${dart-sass.version}"
    }

    afterEvaluate {
      tasks.findByName("downloadSass")?.onlyIf { false }
      tasks.findByName("installSass")?.onlyIf { false }
    }
    EOF

    # Enable missing dependencies
    cat <<EOF >> build.gradle.kts

    dependencies {
      dokkaPlugin("org.jetbrains.dokka:all-modules-page-plugin:2.0.0")
    }
    EOF

    # Skip failing ktlintKotlinScriptCheck
    cat <<EOF >> build.gradle.kts

    afterEvaluate {
      tasks.findByName("ktlintKotlinScriptCheck")?.onlyIf { false }
    }
    EOF
  '';

  # TODO: There's still not any good place to put strictDeps IMO; opinions here would be appreciated
  strictDeps = true;
  nativeBuildInputs = [
    gradle
    dart-sass
    libarchive
    makeWrapper
  ];
  buildInputs = [
    jre
  ];

  # Why isn't this all just set by the gradle setup hooks?
  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    # "com/gradle#develocity-gradle-plugin/3.19.2": {
    # "jar": "sha256-/GEeiFipAWGYMeodnv0onbf+oooMo9CRq902M2XZUSs=",
    # "module": "sha256-v/C1GHP4JfDi7Y5B71yPoNGAzU4fYESqtdJ69d5/Iqk=",
    # "pom": "sha256-o1Kp2Kf3hXwTMQTU60+ijNnayF6af08dyWiuYhE9jvA="
    # },
    data = ./deps.json;
  };
  __darwinAllowLocalNetworking = true;
  gradleFlags = [
    # Was in the nixpkgs gradle docs; I'm not going to remove it
    "-Dfile.encoding=utf-8"
    # Display useful messages for troubleshooting
    "--stacktrace"
    "--info"
  ];

  # TODO: Enable
  # Right now, too many tests that depend on networking and no clear way to disable
  doCheck = false;

  # Apparently there isn't even a default installPhase
  installPhase = ''
    runHook preInstall

    mkdir -p $out
    bsdtar -xf build/distributions/quarkdown.zip --strip-components 1 -C "$out"

    # Remove windows scripts
    rm $out/bin/*.bat

    # Set JAVA_HOME
    for script in $out/bin/*; do
      wrapProgram $script --set-default JAVA_HOME "${jre.home}"
    done

    runHook postInstall
  '';

  meta = {
    description = "Modern Markdown-based typesetting system";
    homepage = "https://github.com/iamgio/quarkdown";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pandapip1 ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # gradle mitmCache
    ];
  };
})
