{ fetchFromGitHub
, fetchurl
, fetchzip
, lib
, linkFarm
, makeWrapper
, runCommand
, stdenv
, stdenvNoCC
, rustPlatform

, ant
, cmake
, glib
, glibc
, jetbrains
, kotlin
, libdbusmenu
, maven
, p7zip
, pkg-config
, xorg

, version
, buildNumber
, buildType
, ideaHash
, androidHash
, jpsHash
, restarterHash
, mvnDeps
}:

let

  jbr = jetbrains.jdk-no-jcef-17;

  ideaSrc = fetchFromGitHub {
    owner = "jetbrains";
    repo = "intellij-community";
    rev = "${buildType}/${buildNumber}";
    hash = ideaHash;
  };

  androidSrc = fetchFromGitHub {
    owner = "jetbrains";
    repo = "android";
    rev = "${buildType}/${buildNumber}";
    hash = androidHash;
  };

  src = runCommand "source" { } ''
    cp -r ${ideaSrc} $out
    chmod +w -R $out
    cp -r ${androidSrc} $out/android
  '';

  libdbusmenu-jb = libdbusmenu.overrideAttrs (old: {
    version = "jetbrains-fork";
    src = fetchFromGitHub {
      owner = "jetbrains";
      repo = "libdbusmenu";
      rev = "d8a49303f908a272e6670b7cee65a2ba7c447875";
      hash = "sha256-u87ZgbfeCPJ0qG8gsom3gFaZxbS5NcHEodb0EVakk60=";
    };
    configureFlags = old.configureFlags ++ [
      "--enable-static"
    ];
    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib
      cp libdbusmenu-glib/.libs/libdbusmenu-glib.a $out/lib

      runHook postInstall
    '';
  });

  libdbm = stdenv.mkDerivation {
    pname = "libdbm";
    version = buildNumber;
    nativeBuildInputs = [ cmake pkg-config ];
    buildInputs = [ glib xorg.libX11 libdbusmenu ];
    inherit src;
    sourceRoot = "${src.name}/native/LinuxGlobalMenu";
    patches = [ ../patches/libdbm-headers.patch ];
    postPatch = "cp ${libdbusmenu-jb}/lib/libdbusmenu-glib.a libdbusmenu-glib.a";
    passthru.patched-libdbusmenu = libdbusmenu-jb;
    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib
      mv libdbm.so $out/lib/libdbm.so

      runHook postInstall
    '';
  };

  fsnotifier = stdenv.mkDerivation {
    pname = "fsnotifier";
    version = buildNumber;
    inherit src;
    sourceRoot = "${src.name}/native/fsNotifier/linux";
    buildPhase = ''
      runHook preBuild
      $CC -O2 -Wall -Wextra -Wpedantic -D "VERSION=\"${buildNumber}\"" -std=c11 main.c inotify.c util.c -o fsnotifier
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      mv fsnotifier $out/bin
      runHook postInstall
    '';
  };

  restarter = rustPlatform.buildRustPackage {
    pname = "restarter";
    version = buildNumber;
    inherit src;
    sourceRoot = "${src.name}/native/restarter";
    cargoHash = restarterHash;

    # Allow static linking
    buildInputs = [ glibc glibc.static ];
  };

  jpsRepo = runCommand "jps-bootstrap-repository"
    {
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
      outputHash = jpsHash;
      nativeBuildInputs = [ ant jbr ];
    } ''
    ant -Duser.home=$out -Dbuild.dir=/build/tmp -f ${src}/platform/jps-bootstrap/jps-bootstrap-classpath.xml
    find $out -type f \( \
      -name \*.lastUpdated \
      -o -name resolver-status.properties \
      -o -name _remote.repositories \) \
      -delete
  '';

  jps-bootstrap = stdenvNoCC.mkDerivation {
    pname = "jps-bootstrap";
    version = buildNumber;
    inherit src;
    sourceRoot = "${src.name}/platform/jps-bootstrap";
    nativeBuildInputs = [ ant makeWrapper jbr ];
    patches = [ ../patches/kotlinc-path.patch ];
    postPatch = "sed -i 's|KOTLIN_PATH_HERE|${kotlin}|' src/main/java/org/jetbrains/jpsBootstrap/KotlinCompiler.kt";
    buildPhase = ''
      runHook preInstall

      ant -Duser.home=${jpsRepo} -Dbuild.dir=/build/out -f jps-bootstrap-classpath.xml

      runHook postInstall
    '';
    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/java/
      cp /build/out/jps-bootstrap.classes.jar $out/share/java/jps-bootstrap.jar
      cp -r /build/out/jps-bootstrap.out.lib $out/share/java/jps-bootstrap-classpath
      makeWrapper ${jbr}/bin/java $out/bin/jps-bootstrap \
        --add-flags "-cp $out/share/java/jps-bootstrap-classpath/'*' org.jetbrains.jpsBootstrap.JpsBootstrapMain"

      runHook postInstall
    '';
  };

  artefactsJson = lib.importJSON mvnDeps;
  mkRepoEntry = entry: {
    name = ".m2/repository/" + entry.path;
    path = fetchurl {
      urls = [
        "https://cache-redirector.jetbrains.com/repo1.maven.org/maven2/${entry.url}"
        "https://cache-redirector.jetbrains.com/packages.jetbrains.team/maven/p/ij/intellij-dependencies/${entry.url}"
        "https://cache-redirector.jetbrains.com/maven.pkg.jetbrains.space/kotlin/p/kotlin/kotlin-ide-plugin-dependencies/${entry.url}"
        "https://cache-redirector.jetbrains.com/packages.jetbrains.team/maven/p/grazi/grazie-platform-public/${entry.url}"
        "https://cache-redirector.jetbrains.com/dl.google.com/dl/android/maven2/${entry.url}"
        "https://packages.jetbrains.team/maven/p/kpm/public/${entry.url}"
        "https://packages.jetbrains.team/maven/p/ki/maven/${entry.url}"
        "https://packages.jetbrains.team/maven/p/dpgpv/maven/${entry.url}"
        "https://cache-redirector.jetbrains.com/download.jetbrains.com/teamcity-repository/${entry.url}"
        "https://cache-redirector.jetbrains.com/maven.pkg.jetbrains.space/kotlin/p/kotlin/kotlin-ide-plugin-dependencies/${entry.url}"
        "https://cache-redirector.jetbrains.com/maven.pkg.jetbrains.space/public/p/compose/dev/${entry.url}"
      ];
      sha256 = entry.hash;
    };
  };
  mvnRepo = linkFarm "intellij-deps" (map mkRepoEntry artefactsJson);

  kotlin-jps-plugin-classpath =
    let
      repoUrl = "https://cache-redirector.jetbrains.com/maven.pkg.jetbrains.space/kotlin/p/kotlin/kotlin-ide-plugin-dependencies";
      groupId = builtins.replaceStrings [ "." ] [ "/" ] "org.jetbrains.kotlin";
      artefactId = "kotlin-jps-plugin-classpath";
      version = "2.0.21-RC";
    in
    fetchurl {
      url = repoUrl + "/" + groupId + "/" + artefactId + "/" + version + "/" + artefactId + "-" + version + ".jar";
      hash = "sha256-jFjxP1LGjrvc1x2XqF5gg/SeKdSFNefxABBlrYl81zA=";
    };

    targetClass = if buildType == "pycharm" then "intellij.pycharm.community.build" else "intellij.idea.community.build";
    targetName = if buildType == "pycharm" then "PyCharmCommunityInstallersBuildTarget" else "OpenSourceCommunityInstallersBuildTarget";

  xplat-launcher = fetchzip {
    url = "https://cache-redirector.jetbrains.com/intellij-dependencies/org/jetbrains/intellij/deps/launcher/242.22926/launcher-242.22926.tar.gz";
    hash = "sha256-ttrQZUbBvvyH1BSVt1yWOoD82WwRi/hkoRfrsdCjwTA=";
    stripRoot = false;
  };

in
stdenvNoCC.mkDerivation rec {
  pname = "${buildType}-community";
  inherit version buildNumber;
  name = "${pname}-${version}.tar.gz";
  inherit src;
  nativeBuildInputs = [ p7zip jbr jps-bootstrap ];
  repo = mvnRepo;

  patches = [
    ../patches/no-download.patch
    ../patches/disable-sbom-generation.patch
    ../patches/bump-jackson-core-in-source.patch
  ];

  postPatch = ''
    cp ${restarter}/bin/restarter bin/linux/amd64/restarter
    cp ${fsnotifier}/bin/fsnotifier bin/linux/amd64/fsnotifier
    cp ${libdbm}/lib/libdbm.so bin/linux/amd64/libdbm.so

    substituteInPlace \
      platform/build-scripts/src/org/jetbrains/intellij/build/kotlin/KotlinCompilerDependencyDownloader.kt \
      --replace-fail 'JPS_PLUGIN_CLASSPATH_HERE' '${kotlin-jps-plugin-classpath}' \
      --replace-fail 'KOTLIN_PATH_HERE' '${kotlin}'
    substituteInPlace \
      platform/build-scripts/downloader/src/org/jetbrains/intellij/build/dependencies/JdkDownloader.kt \
      --replace-fail 'JDK_PATH_HERE' '${jbr}/lib/openjdk'
    substituteInPlace \
      platform/build-scripts/src/org/jetbrains/intellij/build/impl/brokenPlugins.kt \
      --replace-fail 'BROKEN_PLUGINS_HERE' '${./brokenPlugins.json}'
    substituteInPlace \
      platform/build-scripts/src/org/jetbrains/intellij/build/impl/LinuxDistributionBuilder.kt \
      --replace-fail 'XPLAT_LAUNCHER_PREBUILT_PATH_HERE' '${xplat-launcher}'
    substituteInPlace \
      build/deps/src/org/jetbrains/intellij/build/impl/BundledMavenDownloader.kt \
      --replace-fail 'MAVEN_REPO_HERE' '${mvnRepo}/.m2/repository/' \
      --replace-fail 'MAVEN_PATH_HERE' '${maven}/maven'

    echo '${buildNumber}.SNAPSHOT' > build.txt
  '';

  configurePhase = ''
    runHook preConfigure

    ln -s "$repo"/.m2 /build/.m2
    export JPS_BOOTSTRAP_COMMUNITY_HOME=/build/source
    jps-bootstrap \
      -Dbuild.number=${buildNumber} \
      -Djps.kotlin.home=${kotlin} \
      -Dintellij.build.target.os=linux \
      -Dintellij.build.target.arch=x64 \
      -Dintellij.build.skip.build.steps=mac_artifacts,mac_dmg,mac_sit,windows_exe_installer,windows_sign,repair_utility_bundle_step,sources_archive \
      -Dintellij.build.unix.snaps=false \
      --java-argfile-target=java_argfile \
      /build/source \
      ${targetClass} \
      ${targetName}

    runHook postConfigure
  '';
  buildPhase = ''
    runHook preBuild

    java \
      -Djps.kotlin.home=${kotlin} \
      "@java_argfile"

    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mv out/*/artifacts/*-no-jbr.tar.gz $out
    runHook postInstall
  '';

  passthru = {
    inherit libdbm fsnotifier jps-bootstrap;
  };
}
