{
  lib,
  callPackage,
  fetchurl,
  jdk_headless,
  makeWrapper,
  nix-update-script,
  runCommand,
  stdenvNoCC,
  testers,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "maven";
  version = "3.9.12";

  src = fetchurl {
    url = "mirror://apache/maven/maven-3/${finalAttrs.version}/binaries/apache-maven-${finalAttrs.version}-bin.tar.gz";
    hash = "sha256-+iyZSHKSlsI6/Rj9AakPYs3aCaRhkbVKi8N2TC7ugS4=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/maven
    cp -r apache-maven-${finalAttrs.version}/* $out/maven

    makeWrapper $out/maven/bin/mvn $out/bin/mvn \
      --set-default JAVA_HOME "${jdk_headless}"
    makeWrapper $out/maven/bin/mvnDebug $out/bin/mvnDebug \
      --set-default JAVA_HOME "${jdk_headless}"

    runHook postInstall
  '';

  passthru =
    let
      makeOverridableMavenPackage =
        mavenRecipe: mavenArgs:
        let
          drv = mavenRecipe mavenArgs;
          overrideWith =
            newArgs: mavenArgs // (if lib.isFunction newArgs then newArgs mavenArgs else newArgs);
        in
        drv
        // {
          overrideMavenAttrs = newArgs: makeOverridableMavenPackage mavenRecipe (overrideWith newArgs);
        };

      # Exposed so other Maven versions (e.g. maven_4) can reuse the builder
      # without duplicating build-maven-package.nix.
      mkBuildMavenPackage =
        maven:
        makeOverridableMavenPackage (
          callPackage ./build-maven-package.nix {
            inherit maven;
          }
        );
    in
    {
      buildMaven = callPackage ./build-maven.nix {
        maven = finalAttrs.finalPackage;
      };

      inherit mkBuildMavenPackage;

      buildMavenPackage = mkBuildMavenPackage finalAttrs.finalPackage;

      # Local repository of the plugins this Maven version binds implicitly.
      # Merged into the build-time repository by buildMavenPackage so a Maven
      # upgrade does not require recomputing every package's mvnHash. The hash
      # only changes when maven itself is upgraded.
      defaultPluginsRepo = callPackage ./default-plugins.nix {
        maven = finalAttrs.finalPackage;
      };

      # maven's src is a `mirror://apache` tarball, so the version is discovered
      # from the upstream git tags instead, restricted to the 3.x series so it
      # does not jump to the separate maven_4 package. The defaultPluginsRepo
      # outputHash is bumped in the same run via --subpackage.
      updateScript = nix-update-script {
        extraArgs = [
          "--url"
          "https://github.com/apache/maven"
          "--version-regex"
          "maven-(3\\..*)"
          "--subpackage"
          "defaultPluginsRepo"
        ];
      };

      tests = {
        version = testers.testVersion {
          package = finalAttrs.finalPackage;
          command = ''
            env MAVEN_OPTS="-Dmaven.repo.local=$TMPDIR/m2" \
              mvn --version
          '';
        };

        # Regression test for defaultPluginsRepo: the plugins that Maven binds
        # implicitly must actually be present and resolvable, otherwise offline
        # builds of packages that do not pin plugin versions break after a
        # Maven upgrade. Asserts against a fixed list of core lifecycle plugins
        # (an independent source of truth, so a broken extractor cannot make
        # the test vacuously pass).
        defaultPlugins =
          runCommand "maven-default-plugins-test"
            {
              repo = finalAttrs.finalPackage.defaultPluginsRepo;
            }
            ''
              plugins="$repo/.m2/org/apache/maven/plugins"
              for plugin in \
                maven-resources-plugin \
                maven-compiler-plugin \
                maven-surefire-plugin \
                maven-jar-plugin \
                maven-install-plugin \
                maven-deploy-plugin \
                maven-clean-plugin
              do
                if ! ls "$plugins/$plugin"/*/"$plugin"-*.jar >/dev/null 2>&1; then
                  echo "default plugin $plugin missing from defaultPluginsRepo" >&2
                  exit 1
                fi
                echo "found $plugin"
              done
              touch "$out"
            '';
      };
    };

  meta = {
    homepage = "https://maven.apache.org/";
    description = "Build automation tool (used primarily for Java projects)";
    longDescription = ''
      Apache Maven is a software project management and comprehension
      tool. Based on the concept of a project object model (POM), Maven can
      manage a project's build, reporting and documentation from a central piece
      of information.
    '';
    changelog = "https://maven.apache.org/docs/${finalAttrs.version}/release-notes.html";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = lib.licenses.asl20;
    mainProgram = "mvn";
    maintainers = with lib.maintainers; [
      tricktron
      britter
    ];
    teams = [ lib.teams.java ];
    inherit (jdk_headless.meta) platforms;
  };
})
