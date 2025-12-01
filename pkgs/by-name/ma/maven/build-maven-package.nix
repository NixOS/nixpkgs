{
  lib,
  stdenv,
  jdk,
  jre-generate-cacerts,
  maven,
  perl,
  writers,
}:

{
  src,
  sourceRoot ? null,
  buildOffline ? false,
  doCheck ? true,
  patches ? [ ],
  pname,
  version,
  mvnJdk ? jdk,
  mvnHash ? "",
  mvnFetchExtraArgs ? { },
  mvnDepsParameters ? "",
  manualMvnArtifacts ? [ ],
  manualMvnSources ? [ ],
  mvnParameters ? "",
  ...
}@args:

# originally extracted from dbeaver
# created to allow using maven packages in the same style as rust

let
  mvnSkipTests = lib.optionalString (!doCheck) "-DskipTests";

  writeProxySettings = writers.writePython3 "write-proxy-settings" { } ./maven-proxy.py;

  fetchedMavenDeps = stdenv.mkDerivation (
    {
      pname = "maven-deps-${pname}";
      inherit
        src
        sourceRoot
        patches
        version
        ;

      nativeBuildInputs = [
        maven
      ]
      ++ args.nativeBuildInputs or [ ];

      JAVA_HOME = mvnJdk;

      impureEnvVars = lib.fetchers.proxyImpureEnvVars;

      buildPhase = ''
        runHook preBuild

        MAVEN_EXTRA_ARGS=""

        # handle proxy
        if [[ -n "''${HTTP_PROXY-}" ]] || [[ -n "''${HTTPS_PROXY-}" ]] || [[ -n "''${NO_PROXY-}" ]];then
          mvnSettingsFile="$(mktemp -d)/settings.xml"
          ${writeProxySettings} $mvnSettingsFile
          MAVEN_EXTRA_ARGS="-s=$mvnSettingsFile"
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

        runHook postInstall
      '';

      # don't do any fixup
      dontFixup = true;
      outputHashAlgo = if mvnHash != "" then null else "sha256";
      outputHashMode = "recursive";
      outputHash = mvnHash;
    }
    // mvnFetchExtraArgs
  );
in
stdenv.mkDerivation (
  removeAttrs args [ "mvnFetchExtraArgs" ]
  // {
    inherit fetchedMavenDeps;

    nativeBuildInputs = args.nativeBuildInputs or [ ] ++ [
      maven
    ];

    JAVA_HOME = mvnJdk;

    buildPhase = ''
      runHook preBuild

      mvnDeps=$(cp -dpR ${fetchedMavenDeps}/.m2 ./ && chmod +w -R .m2 && pwd)
      runHook afterDepsSetup
      mvn package -o -nsu "-Dmaven.repo.local=$mvnDeps/.m2" ${mvnSkipTests} ${mvnParameters}

      runHook postBuild
    '';

    meta = args.meta or { } // {
      platforms = args.meta.platforms or maven.meta.platforms;
    };
  }
)
