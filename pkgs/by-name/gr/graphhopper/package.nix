{
  fetchFromGitHub,
  stdenv,
  jre,
  maven,
  fetchurl,
  makeWrapper,
  lib,
  ...
}:
let
  version = {
    # Graphhopper releases are tagged under proper semver - `10.2`, but the
    # version included in the `pom.xml` to compile under does not get updated:
    #
    # In pracice that means compiling patch `10.2` produces
    # `graphhopper-web-10.0-SNAPSHOT.jar` and not
    # `graphhopper-web-10.2-SNAPSHOT.jar` like one would expect
    major = "10.0";
    patch = "10.2";

    # The version of the mapsBundle to download
    # Semver is not used, hashes are instead
    # See https://www.npmjs.com/package/@graphhopper/graphhopper-maps-bundle?activeTab=versions
    mapsBundle = "0.0.0-4718098d1db1798841a4d12f1727e8e8f7eab202";
  };

  src = fetchFromGitHub {
    owner = "graphhopper";
    repo = "graphhopper";
    tag = version.patch;
    hash = "sha256-E6G9JR1lrXhNJ4YgMM0n0RsQcMZQM2QldGc74f5FALo=";
  };

  # Patch graphhopper to remove the npm download
  patches = [ ./remove-npm-dependency.patch ];

  # Graphhopper also relies on a maps bundle downloaded from npm
  # By default it installs nodejs and npm during the build,
  # But we patch that out so we much fetch it ourselves
  mapsBundle = fetchurl {
    name = "@graphhopper/graphhopper-maps-bundle-${version.mapsBundle}";
    url = "https://registry.npmjs.org/@graphhopper/graphhopper-maps-bundle/-/graphhopper-maps-bundle-${version.mapsBundle}.tgz";
    hash = "sha256-jZTNJfmMWJQHpJ8um3yTBx/KtIfdr0EwKJ9kSFalWJQ=";
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
      find $out/.m2 -type f -regex '.+\\(\\.lastUpdated\\|resolver-status\\.properties\\|_remote\\.repositories\\)' -delete
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "034s4vg7bh46xvp522gh44kv02h643mq8cww2kp8as80drid3x28";
  };
in
stdenv.mkDerivation {
  pname = "graphhopper";

  inherit src patches;

  version = version.patch;

  buildInputs = [
    makeWrapper
    maven
  ];

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
    find $out/lib -type f -regex '.+\\(\\.lastUpdated\\|resolver-status\\.properties\\|_remote\\.repositories\\)' -delete

    runHook postFixup
  '';

  meta = {
    description = "Fast and memory-efficient routing engine for OpenStreetMap";
    homepage = "https://www.graphhopper.com/";
    changelog = "https://github.com/graphhopper/graphhopper/releases/tag/${version.patch}";
    license = lib.licenses.asl20;
    maintainers = [
      lib.maintainers.baileylu
      lib.teams.geospatial
    ];
    platforms = lib.platforms.all;
    mainProgram = "graphhopper";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };
}
