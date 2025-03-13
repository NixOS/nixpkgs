# originally extracted from dbeaver
# created to allow using maven packages in the same style as rust
{
  lib,
  stdenv,
  jdk,
  maven,
}:

let
  # almost the some as lib.extends, but it doesn't do `prev //`
  transforms =
    transformation: rattrs: # <--- inputs
    final:
    transformation final (rattrs final);
in

let
  transformAttrs =
    finalAttrs: inputAttrs:
    let
      mvnSkipTests = lib.optionalString (!finalAttrs.doCheck) "-DskipTests";
    in
    {
      buildOffline = false;
      doCheck = true;
      mvnJdk = jdk;
      mvnHash = "";
      mvnParameters = "";
      mvnDepsParameters = "";
      manualMvnArtifacts = [ ];
      manualMvnSources = [ ];

      fetchedMavenDeps = stdenv.mkDerivation (
        {
          name = "${finalAttrs.pname}-${finalAttrs.version}-maven-deps";
          src = finalAttrs.src or null;
          sourceRoot = finalAttrs.sourceRoot or null;
          patches = finalAttrs.patches or [ ];

          nativeBuildInputs = [ maven ] ++ inputAttrs.nativeBuildInputs or [ ];

          JAVA_HOME = finalAttrs.mvnJdk;

          buildPhase =
            ''
              runHook preBuild
            ''
            + lib.optionalString finalAttrs.buildOffline ''
              mvn de.qaware.maven:go-offline-maven-plugin:1.2.8:resolve-dependencies -Dmaven.repo.local=$out/.m2 ${finalAttrs.mvnDepsParameters}

              for artifactId in ${builtins.toString finalAttrs.manualMvnArtifacts}
              do
                echo "downloading manual $artifactId"
                mvn dependency:get -Dartifact="$artifactId" -Dmaven.repo.local=$out/.m2
              done

              for artifactId in ${builtins.toString finalAttrs.manualMvnSources}
              do
                group=$(echo $artifactId | cut -d':' -f1)
                artifact=$(echo $artifactId | cut -d':' -f2)
                echo "downloading manual sources $artifactId"
                mvn dependency:sources -DincludeGroupIds="$group" -DincludeArtifactIds="$artifact" -Dmaven.repo.local=$out/.m2
              done
            ''
            + lib.optionalString (!finalAttrs.buildOffline) ''
              mvn package -Dmaven.repo.local=$out/.m2 ${mvnSkipTests} ${finalAttrs.mvnParameters}
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

            runHook postInstall
          '';

          # don't do any fixup
          dontFixup = true;
          outputHashAlgo = if finalAttrs.mvnHash != "" then null else "sha256";
          outputHashMode = "recursive";
          outputHash = finalAttrs.mvnHash;
        }
        // inputAttrs.mvnFetchExtraArgs or { }
      );

      JAVA_HOME = finalAttrs.mvnJdk;

      buildPhase = ''
        runHook preBuild

        mvnDeps=$(cp -dpR ${finalAttrs.fetchedMavenDeps}/.m2 ./ && chmod +w -R .m2 && pwd)
        runHook afterDepsSetup
        mvn package -o -nsu "-Dmaven.repo.local=$mvnDeps/.m2" ${mvnSkipTests} ${finalAttrs.mvnParameters}

        runHook postBuild
      '';

    }
    // builtins.removeAttrs inputAttrs [ "mvnFetchExtraArgs" ]
    // {
      nativeBuildInputs = [ maven ] ++ inputAttrs.nativeBuildInputs or [ ];

      meta = {
        platforms = maven.meta.platforms;
      } // inputAttrs.meta or { };
    };
in

argsOrFn: stdenv.mkDerivation (transforms transformAttrs (lib.toFunction argsOrFn))
