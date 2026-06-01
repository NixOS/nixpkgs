{
  lib,
  stdenv,
  jdk,
  jre-generate-cacerts,
  maven,
  writers,
}:
let
  buildMavenPackage =
    {
      src,
      sourceRoot ? null,
      buildOffline ? false,
      doCheck ? true,
      prePatch ? null,
      patches ? [ ],
      postPatch ? null,
      pname,
      version,
      mvnJdk ? jdk,
      mvnHash ? "",
      /**
        Maven goal to execute. Normally the the default should be used, but some special cases need other goals.
      */
      mvnGoal ? "package",
      /**
        Set the Maven offline argument, `-o`. Normally the default is preferred, but to call `mvn deploy` with
        a directory destination `-o` must be removed. In that case we rely on the Nix sandbox to keep things hermetic.
      */
      mvnOffline ? true,
      mvnFetchExtraArgs ? { },
      mvnDepsParameters ? "",
      manualMvnArtifacts ? [ ],
      manualMvnSources ? [ ],
      mvnParameters ? "",
      useDefaultMavenPlugins ? true,
      ...
    }@args:

    # originally extracted from dbeaver
    # created to allow using maven packages in the same style as rust

    let
      mvnSkipTests = lib.optionalString (!doCheck) "-DskipTests";

      # Path to this Maven version's implicit default plugins, or "" when it
      # should not (or cannot) contribute any. Not every Maven exposes
      # `defaultPluginsRepo` (e.g. maven_4, or a custom distribution built via
      # `overrideMavenAttrs`), and this builder is shared across all of them via
      # `mkBuildMavenPackage`; resolving to "" here lets the build phase skip the
      # merge instead of failing to evaluate on a missing attribute. Laziness
      # keeps `maven.defaultPluginsRepo` unforced when the guard is false.
      defaultPluginsRepo = lib.optionalString (
        useDefaultMavenPlugins && maven ? defaultPluginsRepo
      ) "${maven.defaultPluginsRepo}/default-plugins-repo";

      writeProxySettings = writers.writePython3 "write-proxy-settings" { } ./maven-proxy.py;

      fetchedMavenDeps = stdenv.mkDerivation (
        {
          pname = "maven-deps-${pname}";
          inherit
            src
            sourceRoot
            prePatch
            patches
            postPatch
            version
            ;

          nativeBuildInputs = [
            maven
          ]
          ++ args.nativeBuildInputs or [ ];

          env = mvnFetchExtraArgs.env or { } // {
            JAVA_HOME = mvnJdk;
          };

          impureEnvVars = lib.fetchers.proxyImpureEnvVars;

          buildPhase = ''
            runHook preBuild

            MAVEN_EXTRA_ARGS="-B"

            # handle proxy
            if [[ -n "''${HTTP_PROXY-}" ]] || [[ -n "''${HTTPS_PROXY-}" ]] || [[ -n "''${NO_PROXY-}" ]];then
              mvnSettingsFile="$(mktemp -d)/settings.xml"
              ${writeProxySettings} $mvnSettingsFile
              MAVEN_EXTRA_ARGS="$MAVEN_EXTRA_ARGS -s=$mvnSettingsFile"
            fi

            # handle cacert by populating a trust store on the fly
            if [[ -n "''${NIX_SSL_CERT_FILE-}" ]] && [[ "''${NIX_SSL_CERT_FILE-}" != "/no-cert-file.crt" ]];then
              echo "using ''${NIX_SSL_CERT_FILE-} as trust store"
              ${jre-generate-cacerts} ${lib.getBin jdk}/bin/keytool $NIX_SSL_CERT_FILE

              MAVEN_EXTRA_ARGS="$MAVEN_EXTRA_ARGS -Djavax.net.ssl.trustStore=cacerts -Djavax.net.ssl.trustStorePassword=changeit"
            fi
          ''
          + lib.optionalString buildOffline ''
            mvn $MAVEN_EXTRA_ARGS de.qaware.maven:go-offline-maven-plugin:1.2.8:resolve-dependencies -Dmaven.repo.local=$out/.m2 ${mvnDepsParameters}

            for artifactId in ${toString manualMvnArtifacts}
            do
              echo "downloading manual $artifactId"
              mvn $MAVEN_EXTRA_ARGS dependency:get -Dartifact="$artifactId" -Dmaven.repo.local=$out/.m2
            done

            for artifactId in ${toString manualMvnSources}
            do
              group=$(echo $artifactId | cut -d':' -f1)
              artifact=$(echo $artifactId | cut -d':' -f2)
              echo "downloading manual sources $artifactId"
              mvn $MAVEN_EXTRA_ARGS dependency:sources -DincludeGroupIds="$group" -DincludeArtifactIds="$artifact" -Dmaven.repo.local=$out/.m2
            done
          ''
          + lib.optionalString (!buildOffline) ''
            mvn $MAVEN_EXTRA_ARGS package -Dmaven.repo.local=$out/.m2 ${mvnSkipTests} ${mvnParameters}
          ''
          + ''
            runHook postBuild
          '';

          # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
          installPhase = ''
            runHook preInstall

            find $out -type f \( \
              -name \*.lastUpdated \
              -o -name resolver-status.properties \
              -o -name _remote.repositories \) \
              -delete
            rm -rf $out/.m2/.meta

            runHook postInstall
          '';

          # don't do any fixup
          dontFixup = true;
          outputHashAlgo = if mvnHash != "" then null else "sha256";
          outputHashMode = "recursive";
          outputHash = mvnHash;
        }
        // (removeAttrs mvnFetchExtraArgs [ "env" ])
      );
    in
    stdenv.mkDerivation (
      removeAttrs args [ "mvnFetchExtraArgs" ]
      // {
        inherit fetchedMavenDeps;

        nativeBuildInputs = args.nativeBuildInputs or [ ] ++ [
          maven
        ];

        env = args.env or { } // {
          JAVA_HOME = mvnJdk;
        };

        buildPhase = ''
          runHook preBuild

          mvnDeps=$(cp -dpR ${fetchedMavenDeps}/.m2 ./ && chmod +w -R .m2 && pwd)

          # Merge this Maven version's implicit default plugins into the build
          # repository. Empty when the Maven in use does not provide them (see
          # the defaultPluginsRepo binding above), in which case the merge is
          # skipped.
          defaultPluginsRepo=${lib.escapeShellArg defaultPluginsRepo}
          if [ -n "$defaultPluginsRepo" ]; then
            cp -dpRn "$defaultPluginsRepo/." "$mvnDeps/.m2/"
            chmod +w -R "$mvnDeps/.m2"
          fi

          runHook afterDepsSetup
          mvn ${mvnGoal} ${
            if mvnOffline then "-o" else ""
          } -nsu "-Dmaven.repo.local=$mvnDeps/.m2" ${mvnSkipTests} ${mvnParameters}

          runHook postBuild
        '';

        meta = args.meta or { } // {
          platforms = args.meta.platforms or maven.meta.platforms;
        };
      }
    );
in
fnOrAttrs:
let
  finalPackage =
    if !lib.isFunction fnOrAttrs then
      buildMavenPackage fnOrAttrs
    else
      let
        finalAttrs = fnOrAttrs (finalAttrs // { inherit finalPackage; });
      in
      buildMavenPackage finalAttrs;
in
finalPackage
