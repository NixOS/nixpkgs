{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gradle_8,
  jre,
  dart-sass,
  libarchive,
  makeWrapper,
  coreutils,
  findutils,
  gnused,
  nodejs,
  fetchNpmDeps,
  npmHooks,
  versionCheckHook,
  nix-update-script,
}:

let
  gradle = gradle_8;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "quarkdown";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "iamgio";
    repo = "quarkdown";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m9iP0CtFS1IjoVVnVIrYFxfZidlKa0Z+j1OyVtLgxZc=";
  };

  npmRoot = "quarkdown-html";
  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    src = "${finalAttrs.src}/quarkdown-html";
    hash = "sha256-SP4KkSa9MbR7Tuto7xGaH3kuBlx7YqZ8JJVBaAPkgX8=";
  };

  postPatch = ''
    # Upstream's v2.7.0 tag still has the previous release's version
    substituteInPlace version.txt --replace-quiet "2.6.4" "${finalAttrs.version}"

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
      dokkaPlugin("org.jetbrains.dokka:all-modules-page-plugin:2.2.0")
    }
    EOF

    # Use nixpkgs' JRE instead of a jlink-bundled one (needs a full JDK)
    cat <<EOF >> build.gradle.kts

    afterEvaluate {
      tasks.findByName("bundleRuntime")?.onlyIf { false }
    }
    EOF

    # node_modules is provided by npmConfigHook
    cat <<EOF >> quarkdown-html/build.gradle.kts

    afterEvaluate {
      tasks.findByName("npmInstall")?.onlyIf { false }
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
    nodejs
    npmHooks.npmConfigHook
  ];
  buildInputs = [ jre ];

  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };
  # KSP resolves its processor classpath in detached configurations
  gradleUpdateTask = "nixDownloadDeps :quarkdown-core:kspKotlinJvm :quarkdown-stdlib:kspKotlinJvm :quarkdown-native-library-processor:kspKotlin";
  __darwinAllowLocalNetworking = true;
  gradleFlags = [
    # According to the nixpkgs gradle docs
    "-Dfile.encoding=utf-8"
    # Display useful messages for troubleshooting
    "--stacktrace"
    "--info"
    # Some subprojects don't pin Java and Kotlin to the same JVM target
    "-Pkotlin.jvm.target.validation.mode=warning"
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
      wrapProgram $script \
        --set-default JAVA_HOME "${jre.home}" \
        --prefix PATH : ${
          lib.makeBinPath [
            coreutils
            findutils
            gnused
          ]
        }
    done

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern Markdown-based typesetting system";
    homepage = "https://github.com/iamgio/quarkdown";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pandapip1 ];
    # Build broken on Darwin (seems to try to do non-local networking)
    # I'm assuming this means the BSDs are also broken
    mainProgram = "quarkdown";
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # gradle mitmCache
    ];
  };
})
