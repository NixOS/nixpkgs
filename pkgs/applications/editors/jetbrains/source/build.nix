# TODO: Remove unused inputs & patches, etc.
{
  fetchFromGitHub,
  fetchurl,
  fetchzip,
  lib,
  linkFarm,
  runCommand,
  stdenv,
  rustPlatform,
  callPackage,
  bash,
  replaceVars,
  gcc,
  which,
  # TODO REMOVE
  breakpointHook,
  # TODO REMOVE
  strace,

  ant,
  cmake,
  fsnotifier,
  glib,
  glibc,
  jetbrains,
  libdbusmenu,
  maven,
  p7zip,
  pkg-config,
  libx11,
}:
{
  version,
  buildNumber,
  buildType,
  ideaHash,
  androidHash,
  jpsHash,
  restarterHash,
  mvnDeps,
  repositories,
  kotlin-jps-plugin,
}:
let
  bazel = callPackage ./bazel.nix { };

  # If the build fails, try bumping up the registry commit.
  bazelRegistry = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-central-registry";
    rev = "f1d6000991e45176b121b6ca35b6bf5e24fa9a26";
    hash = "sha256-cAEpCekXY4kT/Y4Un79yyRI3VQUj3NhfF5YCXG1T6qM=";
  };

  rulesKotlinRev = "30e89b8f9a246952e14eb6f56c2265a46bf4dc54";
  rulesKotlin = fetchurl {
    url = "https://github.com/JetBrains/rules_kotlin/archive/${rulesKotlinRev}.zip";
    hash = "sha256-Raj3P9Zj3wLf0pJc974CoDsHXdFPi0c91FT+6qKOVNA=";
  };

  localJdkVersion = "local_jdk_21";
  bazelArgs = [
    #"--verbose_failures"
    #"--sandbox_debug"
    "--enable_bzlmod"
    "--extra_toolchains=@@rules_java++toolchains+local_jdk//:all"
    # more flags are patched into the bazelrc files below
  ];

  jbr = jetbrains.jdk-no-jcef;

  ideaSrc = fetchFromGitHub {
    owner = "jetbrains";
    repo = "intellij-community";
    rev = "${buildType}/${version}";
    hash = ideaHash;
  };

  androidSrc = fetchFromGitHub {
    owner = "jetbrains";
    repo = "android";
    rev = "${buildType}/${version}";
    hash = androidHash;
  };

  javaStubPatch = (
    replaceVars ../patches/rules_java_stub.patch {
      bashPath = lib.getExe bash;
    }
  );

  src = runCommand "intellij-community-source" { } ''
    cp -r ${ideaSrc} $out
    chmod +w -R $out
    cp -r ${androidSrc} $out/android

    # -- Patches for the Bazel build process
    # Enable detection of the CPP toolchain
    substituteInPlace $out/common.bazelrc --replace-fail "common --action_env BAZEL_DO_NOT_DETECT_CPP_TOOLCHAIN=1" ""
    substituteInPlace $out/platform/build-scripts/bazel/.bazelrc --replace-fail "common --action_env BAZEL_DO_NOT_DETECT_CPP_TOOLCHAIN=1" ""

    # Switch to local JDK (JBR)
    substituteInPlace $out/common.bazelrc --replace-fail "common --tool_java_runtime_version=remotejbr_21" "common --tool_java_runtime_version=${localJdkVersion}"
    substituteInPlace $out/common.bazelrc --replace-fail "common --java_runtime_version=remotejbr_21" "common --java_runtime_version=${localJdkVersion}"
    substituteInPlace $out/platform/build-scripts/bazel/.bazelrc --replace-fail "build --tool_java_runtime_version=remotejdk_21" "build --tool_java_runtime_version=${localJdkVersion}"
    substituteInPlace $out/platform/build-scripts/bazel/.bazelrc --replace-fail "build --java_runtime_version=remotejdk_21" "build --java_runtime_version=${localJdkVersion}"

    # Patch the version number (remove JetBrains/ prefix)
    substituteInPlace $out/.bazelversion --replace-fail "JetBrains/" ""
    substituteInPlace $out/platform/build-scripts/bazel/.bazelversion --replace-fail "JetBrains/" ""

    # Build java tools from source - see https://github.com/tweag/rules_nixpkgs/issues/690
    cp ${../patches/rules_java_toolchains.patch} $out/build/rules_java_toolchains.patch
    cp ${../patches/rules_java_toolchains.patch} $out/platform/build-scripts/bazel/build/rules_java_toolchains.patch
    # Fix /usr/bin/env usage in the Java stub
    cp ${javaStubPatch} $out/build/rules_java_stub.patch
    cp ${javaStubPatch} $out/platform/build-scripts/bazel/build/rules_java_stub.patch
    # Patch for OS detection in llvm_toolchains
    cp ${../patches/toolchains_llvm_os_release.patch} $out/build/toolchains_llvm_os_release.patch
    cp ${../patches/toolchains_llvm_os_release.patch} $out/platform/build-scripts/bazel/build/toolchains_llvm_os_release.patch
    # patches are added to MODULE.bazel files in the patches section. - BUILD.bazel file needed to be appliable
    touch $out/platform/build-scripts/bazel/build/BUILD.bazel
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
    nativeBuildInputs = [
      cmake
      pkg-config
    ];
    buildInputs = [
      glib
      libx11
      libdbusmenu
    ];
    inherit src;
    sourceRoot = "${src.name}/native/LinuxGlobalMenu";
    patches = [ ../patches/libdbm-headers.patch ];
    postPatch = ''
      # Fix the build with CMake 4.
      substituteInPlace CMakeLists.txt \
        --replace-fail 'cmake_minimum_required(VERSION 2.6.0)' 'cmake_minimum_required(VERSION 3.10)'
      cp ${libdbusmenu-jb}/lib/libdbusmenu-glib.a libdbusmenu-glib.a
    '';
    passthru.patched-libdbusmenu = libdbusmenu-jb;
    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib
      mv libdbm.so $out/lib/libdbm.so

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
    buildInputs = [
      glibc
      glibc.static
    ];
  };

  artefactsJson = lib.importJSON mvnDeps;
  mkRepoEntry = entry: {
    name = ".m2/repository/" + entry.path;
    path = fetchurl {
      urls = lib.concatMap (url: [
        "https://cache-redirector.jetbrains.com/${url}/${entry.url}"
        "https://${url}/${entry.url}"
      ]) repositories;
      # Do not try to retry 4xx errors
      curlOptsList = [ "--no-retry-all-errors" ];
      sha256 = entry.hash;
    };
  };
  mvnRepo = linkFarm "intellij-deps" (map mkRepoEntry artefactsJson);

  kotlin-jps-plugin-classpath =
    let
      repoBaseUrl = "packages.jetbrains.team/maven/p/ij/intellij-dependencies";
      repoUrls = [
        "https://cache-redirector.jetbrains.com/${repoBaseUrl}"
        "https://${repoBaseUrl}"
      ];
      groupId = "org/jetbrains/kotlin";
      artefactId = "kotlin-jps-plugin-classpath";
      version = kotlin-jps-plugin.version;
    in
    fetchurl {
      urls = map (
        url:
        lib.concatStringsSep "/" [
          url
          groupId
          artefactId
          version
          "${artefactId}-${version}.jar"
        ]
      ) repoUrls;
      hash = kotlin-jps-plugin.hash;
    };

  bazelTarget =
    if buildType == "pycharm" then
      "@community//python/build:i_build_target"
    else
      "//build:i_build_target";

  xplat-launcher = fetchzip {
    urls = [
      "https://cache-redirector.jetbrains.com/intellij-dependencies/org/jetbrains/intellij/deps/launcher/242.22926/launcher-242.22926.tar.gz"
      "https://packages.jetbrains.team/maven/p/ij/intellij-dependencies/org/jetbrains/intellij/deps/launcher/242.22926/launcher-242.22926.tar.gz"
    ];
    hash = "sha256-ttrQZUbBvvyH1BSVt1yWOoD82WwRi/hkoRfrsdCjwTA=";
    stripRoot = false;
  };

  patches = [
    (replaceVars ../patches/module-bazel.patch {
      inherit rulesKotlin rulesKotlinRev;
    })
    (replaceVars ../patches/build-scripts-module-bazel.patch {
      inherit rulesKotlin rulesKotlinRev;
    })
    (replaceVars ../patches/jps-dynamic-deps-env-bash.patch {
      bashPath = lib.getExe bash;
    })
    (replaceVars ../patches/jpsModelToBazelCommunityOnly-env-bash.patch {
      bazelRunArgs = lib.join " " bazelArgs;
      registry = bazelRegistry;
    })
  ];

  refreshedLockfile = bazel.derivation {
    inherit version;
    name = "intellij-community-lockfile";

    inherit src patches;

    bazel = bazel;
    targets = [ ];
    registry = bazelRegistry;

    commandArgs = [ "--lockfile_mode=refresh" ];
    command = "mod deps";

    installPhase = ''
      cp MODULE.bazel.lock $out
    '';

    outputHash = "sha256-io00dmNl6f7ywoo4mrEdzrzdmdy5qrLDX2LalpdpKfU=";
    outputHashAlgo = "sha256";

  };

  pname = "${buildType}-oss";

in
bazel.package {
  inherit version;
  name = "${pname}-${version}.tar.gz";

  inherit src patches;

  nativeBuildInputs = [
    p7zip
    jbr
    bazel
    gcc
    which
    # TODO: Remove
    breakpointHook
    # TODO: Remove
    strace
  ];

  bazel = bazel;
  targets = [ bazelTarget ];
  registry = bazelRegistry;
  commandArgs = bazelArgs;
  fetchAll = true;

  #patches = [
  #../patches/no-download.patch
  #../patches/disable-sbom-generation.patch
  #../patches/bump-jackson-core-in-source.patch
  #];

  # Regarding brokenPlugins.json:
  #  We provide an empty brokenPlugins.json because the original file is 2.8 MB in size and can't be reliably
  #  downloaded without hash changes. The file is not important for the IDEs to function properly.
  #postPatch = ''
  #  cp ${restarter}/bin/restarter bin/linux/amd64/restarter
  #  cp ${fsnotifier}/bin/fsnotifier bin/linux/amd64/fsnotifier
  #  cp ${libdbm}/lib/libdbm.so bin/linux/amd64/libdbm.so
  #
  #  substituteInPlace \
  #    platform/build-scripts/src/org/jetbrains/intellij/build/kotlin/KotlinCompilerDependencyDownloader.kt \
  #    --replace-fail 'JPS_PLUGIN_CLASSPATH_HERE' '${kotlin-jps-plugin-classpath}' \
  #    --replace-fail 'KOTLIN_PATH_HERE' '${kotlin'}'
  #  substituteInPlace \
  #    platform/build-scripts/downloader/src/org/jetbrains/intellij/build/dependencies/JdkDownloader.kt \
  #    --replace-fail 'JDK_PATH_HERE' '${jbr}/lib/openjdk'
  #  substituteInPlace \
  #    platform/build-scripts/src/org/jetbrains/intellij/build/impl/brokenPlugins.kt \
  #    --replace-fail 'BROKEN_PLUGINS_HERE' '${./brokenPlugins.json}'
  #  substituteInPlace \
  #    platform/build-scripts/src/org/jetbrains/intellij/build/impl/LinuxDistributionBuilder.kt \
  #    --replace-fail 'XPLAT_LAUNCHER_PREBUILT_PATH_HERE' '${xplat-launcher}'
  #  substituteInPlace \
  #    build/deps/src/org/jetbrains/intellij/build/impl/BundledMavenDownloader.kt \
  #    --replace-fail 'MAVEN_REPO_HERE' '${mvnRepo}/.m2/repository/' \
  #    --replace-fail 'MAVEN_PATH_HERE' '${maven}/maven'
  #
  #  echo '${buildNumber}.SNAPSHOT' > build.txt
  #'';

  #configurePhase = ''
  #  runHook preConfigure
  #
  #  ln -s "$repo"/.m2 ../.m2
  #  export JPS_BOOTSTRAP_COMMUNITY_HOME="$PWD"
  #  jps-bootstrap \
  #    -Dbuild.number=${buildNumber} \
  #    -Djps.kotlin.home=${kotlin'} \
  #    -Dintellij.build.target.os=linux \
  #    -Dintellij.build.target.arch=x64 \
  #    -Dintellij.build.skip.build.steps=mac_artifacts,mac_dmg,mac_sit,windows_exe_installer,windows_sign,repair_utility_bundle_step,sources_archive \
  #    -Dintellij.build.unix.snaps=false \
  #    --java-argfile-target=java_argfile \
  #    "$PWD" \
  #    ${targetClass} \
  #    ${targetName}
  #
  #  runHook postConfigure
  #'';

  bazelPreBuild = ''
    cp ${refreshedLockfile} MODULE.bazel.lock
  '';

  bazelRepoCacheFOD = {
    outputHash =
      {
        aarch64-linux = ""; # TODO
        x86_64-linux = "";
      }
      .${stdenv.hostPlatform.system};
    outputHashAlgo = "sha256";
  };

  #buildPhase = ''
  #  runHook preBuild
  #
  #  java \
  #    -Djps.kotlin.home=${kotlin'} \
  #   "@java_argfile"
  #
  #  runHook postBuild
  #'';
  installPhase = ''
    runHook preInstall
    mv out/*/artifacts/*-no-jbr.tar.gz $out
    runHook postInstall
  '';

  passthru = {
    inherit
      version
      buildNumber
      libdbm
      fsnotifier
      #jps-bootstrap
      ;
  };
}
