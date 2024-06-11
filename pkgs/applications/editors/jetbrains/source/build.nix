{ fetchFromGitHub
, fetchurl
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
, jetbrains
, kotlin
, libdbusmenu
, maven
, p7zip
, pkg-config
, xorg

, buildVer
, buildType
, ideaHash
, androidHash
, jpsHash
, restarterHash
, mvnDeps
}:

let

  jbr = jetbrains.jdk-no-jcef;

  ideaSrc = fetchFromGitHub {
    owner = "jetbrains";
    repo = "intellij-community";
    rev = "${buildType}/${buildVer}";
    hash = ideaHash;
  };

  androidSrc = fetchFromGitHub {
    owner = "jetbrains";
    repo = "android";
    rev = "${buildType}/${buildVer}";
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
    version = buildVer;
    nativeBuildInputs = [ cmake pkg-config ];
    buildInputs = [ glib xorg.libX11 libdbusmenu ];
    inherit src;
    sourceRoot = "source/native/LinuxGlobalMenu";
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
    version = buildVer;
    inherit src;
    sourceRoot = "source/native/fsNotifier/linux";
    buildPhase = ''
      runHook preBuild
      $CC -O2 -Wall -Wextra -Wpedantic -D "VERSION=\"${buildVer}\"" -std=c11 main.c inotify.c util.c -o fsnotifier
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
    version = buildVer;
    inherit src;
    patches = [ ../patches/restarter-no-static-crt-override.patch ];
    sourceRoot = "source/native/restarter";
    cargoHash = restarterHash;
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
    version = buildVer;
    inherit src;
    sourceRoot = "source/platform/jps-bootstrap";
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
      version = "1.9.10";
    in
    fetchurl {
      url = repoUrl + "/" + groupId + "/" + artefactId + "/" + version + "/" + artefactId + "-" + version + ".jar";
      hash = "sha256-gpB4lg6wailtxSgPyyOrarXCL9+DszojaYGC4ULgU3c=";
    };

    targetClass = if buildType == "pycharm" then "intellij.pycharm.community.build" else "intellij.idea.community.build";
    targetName = if buildType == "pycharm" then "PyCharmCommunityInstallersBuildTarget" else "OpenSourceCommunityInstallersBuildTarget";

in
stdenvNoCC.mkDerivation rec {
  pname = "${buildType}-community";
  version = buildVer;
  name = "${pname}-${version}.tar.gz";
  inherit src;
  nativeBuildInputs = [ p7zip jbr jps-bootstrap ];
  repo = mvnRepo;

  patches = [
    ../patches/no-download.patch
    ../patches/disable-sbom-generation.patch
  ];

  postPatch = ''
    cp ${restarter}/bin/restarter bin/linux/amd64/restarter
    cp ${fsnotifier}/bin/fsnotifier bin/linux/amd64/fsnotifier
    cp ${libdbm}/lib/libdbm.so bin/linux/amd64/libdbm.so

    sed \
      -e 's|JPS_PLUGIN_CLASSPATH_HERE|${kotlin-jps-plugin-classpath}|' \
      -e 's|KOTLIN_PATH_HERE|${kotlin}|' \
      -i platform/build-scripts/src/org/jetbrains/intellij/build/kotlin/KotlinCompilerDependencyDownloader.kt
    sed \
      -e 's|JDK_PATH_HERE|${jbr}/lib/openjdk|' \
      -i platform/build-scripts/downloader/src/org/jetbrains/intellij/build/dependencies/JdkDownloader.kt
    sed \
      -e 's|BROKEN_PLUGINS_HERE|${./brokenPlugins.json}|' \
      -i platform/build-scripts/src/org/jetbrains/intellij/build/impl/brokenPlugins.kt
    sed \
      -e 's|MAVEN_REPO_HERE|${mvnRepo}/.m2/repository/|' \
      -e 's|MAVEN_PATH_HERE|${maven}/maven|' \
      -i build/deps/src/org/jetbrains/intellij/build/impl/BundledMavenDownloader.kt
    echo '${buildVer}' > build.txt
  '';

  configurePhase = ''
    runHook preConfigure

    ln -s "$repo"/.m2 /build/.m2
    export JPS_BOOTSTRAP_COMMUNITY_HOME=/build/source
    jps-bootstrap \
      -Dbuild.number=${buildVer} \
      -Djps.kotlin.home=${kotlin} \
      -Dintellij.build.target.os=linux \
      -Dintellij.build.target.arch=x64 \
      -Dintellij.build.skip.build.steps=mac_artifacts,mac_dmg,mac_sit,windows_exe_installer,windows_sign,repair_utility_bundle_step \
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
