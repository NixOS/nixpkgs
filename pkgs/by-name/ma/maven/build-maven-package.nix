{ lib
, stdenv
, jdk
, maven
}:

{ src
, sourceRoot ? null
, buildOffline ? false
, doCheck ? true
, patches ? [ ]
, pname
, version
, mvnJdk ? jdk
, mvnHash ? ""
, mvnFetchExtraArgs ? { }
, mvnDepsParameters ? ""
, manualMvnArtifacts ? [ ]
, manualMvnSources ? [ ]
, mvnParameters ? ""
, ...
} @args:

# originally extracted from dbeaver
# created to allow using maven packages in the same style as rust

let
  mvnSkipTests = lib.optionalString (!doCheck) "-DskipTests";
  fetchedMavenDeps = stdenv.mkDerivation ({
    name = "${pname}-${version}-maven-deps";
    inherit src sourceRoot patches;

    nativeBuildInputs = [
      maven
    ] ++ args.nativeBuildInputs or [ ];

    JAVA_HOME = mvnJdk;

    buildPhase = ''
      runHook preBuild
    '' + lib.optionalString buildOffline ''
      mvn de.qaware.maven:go-offline-maven-plugin:1.2.8:resolve-dependencies -Dmaven.repo.local=$out/.m2 ${mvnDepsParameters}

      for artifactId in ${builtins.toString manualMvnArtifacts}
      do
        echo "downloading manual $artifactId"
        mvn dependency:get -Dartifact="$artifactId" -Dmaven.repo.local=$out/.m2
      done

      for artifactId in ${builtins.toString manualMvnSources}
      do
        group=$(echo $artifactId | cut -d':' -f1)
        artifact=$(echo $artifactId | cut -d':' -f2)
        echo "downloading manual sources $artifactId"
        mvn dependency:sources -DincludeGroupIds="$group" -DincludeArtifactIds="$artifact" -Dmaven.repo.local=$out/.m2
      done
    '' + lib.optionalString (!buildOffline) ''
      mvn package -Dmaven.repo.local=$out/.m2 ${mvnSkipTests} ${mvnParameters}
    '' + ''
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
    outputHashAlgo = if mvnHash != "" then null else "sha256";
    outputHashMode = "recursive";
    outputHash = mvnHash;
  } // mvnFetchExtraArgs);
in
stdenv.mkDerivation (builtins.removeAttrs args [ "mvnFetchExtraArgs" ] // {
  inherit fetchedMavenDeps;

  nativeBuildInputs = args.nativeBuildInputs or [ ] ++ [
    maven
  ];

  JAVA_HOME = mvnJdk;

  buildPhase = ''
    runHook preBuild

    mvnDeps=$(cp -dpR ${fetchedMavenDeps}/.m2 ./ && chmod +w -R .m2 && pwd)
    mvn package -o -nsu "-Dmaven.repo.local=$mvnDeps/.m2" ${mvnSkipTests} ${mvnParameters}

    runHook postBuild
  '';

  meta = args.meta or { } // {
    platforms = args.meta.platforms or maven.meta.platforms;
  };
})
