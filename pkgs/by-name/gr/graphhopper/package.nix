{
  fetchFromGitHub,
  fetchurl,
  lib,
  stdenv,
  testers,

  jre,
  makeWrapper,
  maven,
  ...
}:
let
  version = builtins.fromTOML (builtins.readFile ./version.toml);

  src = fetchFromGitHub {
    owner = "graphhopper";
    repo = "graphhopper";
    tag = version.patch;
    hash = version.hash.src;
  };

  # Patch graphhopper to remove the npm download
  patches = [ ./remove-npm-dependency.patch ];

  # Graphhopper also relies on a maps bundle downloaded from npm
  # By default it installs nodejs and npm during the build,
  # But we patch that out so we much fetch it ourselves
  mapsBundle = fetchurl {
    name = "@graphhopper/graphhopper-maps-bundle-${version.mapsBundle}";
    url = "https://registry.npmjs.org/@graphhopper/graphhopper-maps-bundle/-/graphhopper-maps-bundle-${version.mapsBundle}.tgz";
    hash = version.hash.mapsBundle;
  };

  # We cannot use `buildMavenPackage` as we need to load in the
  # mapsBundle before doing anything
  mvnDeps = stdenv.mkDerivation {
    name = "graphhopper-dependencies";

    inherit src patches;

    buildInputs = [ maven ];

    buildPhase = ''
      # Fetching deps with mvn dependency:go-offline does not quite catch everything, so we use this plugin instead
      mvn de.qaware.maven:go-offline-maven-plugin:resolve-dependencies \
        -Dmaven.repo.local=$out/.m2 \
        -Dmaven.wagon.rto=5000
    '';

    installPhase = ''
      # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
      find $out -type f \( \
        -name \*.lastUpdated \
        -o -name resolver-status.properties \
        -o -name _remote.repositories \) \
        -delete
    '';

    outputHashMode = "recursive";
    outputHash = version.hash.mvnDeps;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "graphhopper";

  inherit src patches;

  version = version.patch;

  nativeBuildInputs = [
    makeWrapper
    maven
  ];

  strictDeps = true;

  configurePhase = ''
    runHook preConfigure

    mkdir -p ./web-bundle/target/
    ln -s ${mapsBundle} ./web-bundle/target/graphhopper-graphhopper-maps-bundle-${version.mapsBundle}.tgz

    runHook postConfigure
  '';

  # Build and skip tests because downloading of
  # test deps seems to not work with the go-offline plugin
  buildPhase = ''
    runHook preBuild

    mvn package --offline \
      -Dmaven.repo.local=${mvnDeps}/.m2 \
      -DskipTests

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    ln -s ${mvnDeps}/.m2 $out/lib

    # Grapphopper versions are seemingly compiled under the major release name,
    # not the patch name, which is the version we want for our package
    cp ./web/target/graphhopper-web-${version.major}-SNAPSHOT.jar $out/bin/graphhopper-web-${version.major}-SNAPSHOT.jar

    makeWrapper ${jre}/bin/java $out/bin/graphhopper \
      --add-flags "-jar $out/bin/graphhopper-web-${version.major}-SNAPSHOT.jar" \
      --chdir $out

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
    find $out -type f \( \
      -name \*.lastUpdated \
      -o -name resolver-status.properties \
      -o -name _remote.repositories \) \
      -delete

    runHook postFixup
  '';

  meta = {
    description = "Fast and memory-efficient routing engine for OpenStreetMap";
    homepage = "https://www.graphhopper.com/";
    changelog = "https://github.com/graphhopper/graphhopper/releases/tag/${version.patch}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ baileylu ];
    teams = [ lib.teams.geospatial ];
    platforms = lib.platforms.all;
    mainProgram = "graphhopper";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };

  passthru = {
    updateScript = ./update.nu;
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      # `graphhopper --version` does not work as the source does not specify `Implementation-Version`
      command = "graphhopper --help";
      version = "graphhopper-web-${version.major}-SNAPSHOT.jar";
    };
  };
})
