{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gradle_8,
  jre,
  dart-sass,
  libarchive,
  makeWrapper,
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
    # due to https://github.com/EtienneMiret/sass-gradle-plugin
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

  __structuredAttrs = true;
  strictDeps = true;
  nativeBuildInputs = [
    gradle
    dart-sass
    libarchive
    makeWrapper
  ];
  buildInputs = [ jre ];

  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };
  __darwinAllowLocalNetworking = true;
  gradleFlags = [
    # According to the nixpkgs gradle docs
    "-Dfile.encoding=utf-8"
    # Display useful messages for troubleshooting
    "--stacktrace"
    "--info"
  ];

  # TODO(@Pandapip1): Too many tests depend on networking and no clear way to disable those specific tests
  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    bsdtar -xf build/distributions/quarkdown.zip --strip-components 1 -C "$out"

    # Remove windows scripts
    rm $out/bin/*.bat

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
    # Build broken on Darwin (seems to try to do non-local networking)
    # I'm assuming this means the BSDs are also broken
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # gradle mitmCache
    ];
  };
})
