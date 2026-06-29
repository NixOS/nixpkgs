{
  lib,
  stdenv,
  jdk,
  jre-generate-cacerts,
  maven,
  writers,
}:
# A local Maven repository (`$out/default-plugins-repo`) containing the plugins that this Maven
# version binds *implicitly* for the standard lifecycles, plus the version
# defaults from the super POM's `pluginManagement`. `buildMavenPackage` merges
# this repository into the build-time local repository so that packages which
# do not pin their plugin versions keep resolving after a Maven upgrade, without
# baking the plugins into each package's fixed-output derivation (which would
# force recomputing every `mvnHash` on a Maven bump).
let
  writeProxySettings = writers.writePython3 "write-proxy-settings" { } ./maven-proxy.py;
  extractDefaultPlugins =
    writers.writePython3 "extract-default-plugins" { }
      ./extract-default-plugins.py;
in
stdenv.mkDerivation {
  pname = "maven-default-plugins";
  inherit (maven) version;

  dontUnpack = true;

  nativeBuildInputs = [ maven ];

  env.JAVA_HOME = jdk;

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

    for artifact in $(${extractDefaultPlugins} ${maven}/maven/lib)
    do
      echo "downloading default plugin $artifact"
      mvn $MAVEN_EXTRA_ARGS dependency:get -Dartifact="$artifact" -Dmaven.repo.local=$out/default-plugins-repo
    done

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
  # The implicit plugin versions are baked into each Maven release, so this
  # hash only changes when maven is upgraded. It is kept up to date by maven's
  # passthru.updateScript (nix-update --subpackage defaultPluginsRepo).
  outputHashMode = "recursive";
  outputHash = "sha256-0wdHUTWO+sO8ZLKgMYB7XF3ExFNz/sxxhvPiLhm35Gk=";
}
