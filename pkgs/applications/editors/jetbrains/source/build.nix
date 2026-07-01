# TODO: This is currently only supported for x86_64-linux
{
  alsa-lib,
  bash,
  callPackage,
  cmake,
  fetchFromGitHub,
  fetchurl,
  fetchzip,
  fsnotifier,
  glib,
  glibc,
  jetbrains,
  lib,
  libdbusmenu,
  libpanel,
  libx11,
  libxcrypt-legacy,
  libxi,
  libxml2_13,
  libxrender,
  libxtst,
  linkFarm,
  maven,
  ncurses,
  pkg-config,
  python3,
  replaceVars,
  runCommand,
  rustPlatform,
  stdenv,
  xz,
  zlib,
}:
{
  version,
  buildNumber,
  buildType,
  ideaHash,
  androidHash,
  restarterHash,
  bazelConfig,
}:
let
  # The build number with the patch part removed. This is required for the build, since the build appends a patch part itself for plugins, otherwise
  # they fail with an invalid semver version ("The plugin build number 261.25134.95.20260601 is expected to match the Semantic Versioning")
  buildNumberMinor = builtins.concatStringsSep "." (lib.init (lib.splitString "." buildNumber));

  bazel = callPackage ./bazel.nix { } { inherit (bazelConfig) base jbPatches; };
  # If the build fails, try bumping up the registry commit.
  bazelRegistry = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-central-registry";
    inherit (bazelConfig.registry) rev hash;
  };

  localJdkVersion = "local_jdk_21";
  bazelArgs = [
    "--lockfile_mode=off"
    "--features=-module_maps"
    "--host_features=-module_maps"
  ];

  jbr = jetbrains.jdk-no-jcef-21;

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
    src = ideaSrc;
    sourceRoot = "${ideaSrc.name}/native/LinuxGlobalMenu";
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
    src = ideaSrc;
    sourceRoot = "${ideaSrc.name}/native/restarter";

    cargoHash = restarterHash;

    # Allow static linking
    buildInputs = [
      glibc
      glibc.static
    ];
  };

  # These maven artifacts are downloaded by the JPS installer and not provided via Bazel (or at least JPS doesn't pick them up). This is probably a bug in the installer
  # and hopefully something JetBrains will fix, we optimistically asume so. If this doesn't hold true, we might want to revert to pre-fetching all Maven artifacts ourselves
  # instead of maintaining this manual list here. See state before the PR that introduced this change for reference for the automated maven fetching.
  artefacts = [
    {
      repo = "repo.maven.apache.org/maven2";
      path = "org/apache/maven/archetype/archetype-catalog/2.2/archetype-catalog-2.2.jar";
      hash = "sha256-ES4G5qzBQFrTulGEQug10dQnWO8x8Lu9syqh4VoX0Q8=";
    }
    {
      repo = "repo.maven.apache.org/maven2";
      path = "org/apache/maven/shared/maven-dependency-tree/1.2/maven-dependency-tree-1.2.jar";
      hash = "sha256-27jFPMwLFqndg3DW595jECRoyu2sHl+i60GDGaaHUpM=";
    }
    {
      repo = "repo.maven.apache.org/maven2";
      path = "org/sonatype/nexus/nexus-indexer-artifact/1.0.1/nexus-indexer-artifact-1.0.1.jar";
      hash = "sha256-FxA1dAMi+WvYwVXPtgUJYt1h15dqSUwKrG1Gs8gxdMQ=";
    }
    {
      repo = "repo.maven.apache.org/maven2";
      path = "org/apache/lucene/lucene-core/2.4.1/lucene-core-2.4.1.jar";
      hash = "sha256-uF1sKmtMKekPp8XZSyH+eW+caFeHAmi1aQR2USa65xg=";
    }
    {
      repo = "repo.maven.apache.org/maven2";
      path = "org/apache/maven/archetype/archetype-descriptor/2.2/archetype-descriptor-2.2.jar";
      hash = "sha256-Fi/wzIBEUwfeBfXgzpwBTozSLPvS7WEK45gG5FksUlU=";
    }
    {
      repo = "repo.maven.apache.org/maven2";
      path = "org/apache/maven/archetype/archetype-common/2.2/archetype-common-2.2.jar";
      hash = "sha256-OgCngVeoL/93gzR2QlVkJYUSdEPgs9pWvNtvig+RAiA=";
    }
    {
      repo = "repo.maven.apache.org/maven2";
      path = "org/sonatype/nexus/nexus-indexer/3.0.4/nexus-indexer-3.0.4.jar";
      hash = "sha256-nUOijQdYkU/c6iikNmAawm0Go7VdKDu2vgMhzNNjGlg=";
    }
    {
      repo = "repo.maven.apache.org/maven2";
      path = "com/fasterxml/jackson/core/jackson-core/2.19.0/jackson-core-2.19.0.jar";
      hash = "sha256-2o6Fm6yUh0UoEWol8gxoVg5Ch6y/J2KHEbik+WsChDA=";
    }
  ];
  mkRepoEntry = entry: {
    name = ".m2/repository/" + entry.path;
    path = fetchurl {
      urls = [
        "https://cache-redirector.jetbrains.com/${entry.repo}/${entry.path}"
        "https://${entry.repo}/${entry.path}"
      ];
      # Do not try to retry 4xx errors
      curlOptsList = [ "--no-retry-all-errors" ];
      hash = entry.hash;
    };
  };
  mvnRepo = linkFarm "intellij-jps-deps" (map mkRepoEntry artefacts);

  xplat-launcher = fetchzip {
    urls = [
      "https://cache-redirector.jetbrains.com/intellij-dependencies/org/jetbrains/intellij/deps/launcher/242.22926/launcher-242.22926.tar.gz"
      "https://packages.jetbrains.team/maven/p/ij/intellij-dependencies/org/jetbrains/intellij/deps/launcher/242.22926/launcher-242.22926.tar.gz"
    ];
    hash = "sha256-ttrQZUbBvvyH1BSVt1yWOoD82WwRi/hkoRfrsdCjwTA=";
    stripRoot = false;
  };

  bazelTarget =
    if buildType == "pycharm" then
      "@community//python/build:i_build_target"
    else
      "//build:i_build_target";

  pname = "${buildType}-oss";

in
bazel.package {
  inherit version;
  name = "${pname}-${version}.tar.gz";
  src = ideaSrc;

  buildInputs = [
    zlib
    stdenv.cc
    libxi
    libxtst
    alsa-lib
    libxrender
    libxcrypt-legacy
    xz
    ncurses
    libxml2_13
    libpanel
    python3
  ];

  nativeBuildInputs = [
    stdenv.cc
    bash
  ];

  bazel = bazel;
  targets = [ bazelTarget ];
  registry = bazelRegistry;
  commandArgs = bazelArgs;

  postUnpack = ''
    ln -s ${androidSrc} "$sourceRoot/android"
  '';

  patches = [
    ## BAZEL
    (replaceVars ../patches/module.patch { sysroot = lib.getDev stdenv.cc.libc; })
    (bazel.addFilePatch {
      path = "b/build/rules_java_stub.patch";
      file = replaceVars ../patches/rules_java_stub.patch { bash = lib.getExe bash; };
    })
    (bazel.addFilePatch {
      path = "b/platform/build-scripts/bazel/build/rules_java_stub.patch";
      file = replaceVars ../patches/rules_java_stub.patch { bash = lib.getExe bash; };
    })
    ../patches/cc.patch
    (bazel.addFilePatch {
      path = "b/build/cc_wrapper.patch";
      file = replaceVars ../patches/cc_wrapper.patch { bash = lib.getExe bash; };
    })
    (bazel.addFilePatch {
      # TODO: remove with newer idea-oss not using nested bazel for fetch phase
      path = "b/platform/build-scripts/bazel/build/cc_wrapper.patch";
      file = replaceVars ../patches/cc_wrapper.patch { bash = lib.getExe bash; };
    })
    (replaceVars ../patches/bash.patch { bash = lib.getExe bash; })
    (replaceVars ../patches/bazel.patch {
      bazel = lib.getExe bazel;
      commandArgs = lib.concatStringsSep " " (bazelArgs ++ [ "--registry=file://${bazelRegistry}" ]);
    })
    ## INSTALLER
    ../patches/no-download.patch
    ../patches/disable-sbom-generation.patch
    ../patches/bump-jackson-core-in-source.patch
  ];

  autoPatchelfVendorDirs = [
    "toolchains_llvm++llvm+llvm_toolchain_llvm"
    "rules_python++python+python_3_11_x86_64-unknown-linux-gnu"
    "rules_java++toolchains+remote_java_tools_linux"
    "+jbr_toolchains+remotejbr21_linux"
    "rules_java++toolchains+remotejdk25_linux"
  ];

  bazelPreBuild = ''
    ## BAZEL PATCHES
    # Patch the version number (remove JetBrains/ prefix)
    substituteInPlace .bazelversion --replace-fail "JetBrains/" ""
    substituteInPlace platform/build-scripts/bazel/.bazelversion --replace-fail "JetBrains/" ""

    # just in case there's no newline at the end of file
    echo >> platform/build-scripts/bazel/.bazelrc
    # covered by patch
    # echo "common ${builtins.concatStringsSep " " bazelArgs}" >> platform/build-scripts/bazel/.bazelrc
    # echo "common --registry=file://${bazelRegistry}" >> platform/build-scripts/bazel/.bazelrc

    # remote jdk won't work unpatched for repo fetching phase in nested bazel call
    echo "run --extra_toolchains=@@rules_java++toolchains+local_jdk//:all --tool_java_runtime_version=${localJdkVersion} --java_runtime_version=${localJdkVersion}" >> platform/build-scripts/bazel/.bazelrc

    # TODO: tricky decision to make, for read flow nested bazel should see it, but for population flow
    #       there's 2 bazel invocations sharing those dirs - is it safe? Or at least when deps&patches&options are the same?
    # TODO: repo_cache&vendor_dir location being the same for read&populate flows might change in future?
    [ -d repo_cache ] && echo "common --repository_cache=../../../repo_cache" >> platform/build-scripts/bazel/.bazelrc
    [ -d vendor_dir ] && echo "common --vendor_dir=../../../vendor_dir" >> platform/build-scripts/bazel/.bazelrc

    ## INSTALLER PATCHES
    cp ${restarter}/bin/restarter bin/linux/amd64/restarter
    cp ${fsnotifier}/bin/fsnotifier bin/linux/amd64/fsnotifier
    cp ${libdbm}/lib/libdbm.so bin/linux/amd64/libdbm.so

    substituteInPlace \
      platform/build-scripts/downloader/src/org/jetbrains/intellij/build/dependencies/JdkDownloader.kt \
      --replace-fail 'JDK_PATH_HERE' '${jbr}/lib/openjdk'
    # Regarding brokenPlugins.json:
    #  We provide an empty brokenPlugins.json because the original file is 2.8 MB in size and can't be reliably
    #  downloaded without hash changes. The file is not important for the IDEs to function properly.
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

    echo '${buildNumberMinor}.SNAPSHOT' > build.txt
  '';

  installPhase = ''
    runHook preInstall

    ${bazel}/bin/bazel run \
      --registry=file://${bazelRegistry} \
      --repository_cache=repo_cache \
      --vendor_dir=vendor_dir ${builtins.concatStringsSep " " bazelArgs} \
      ${bazelTarget} \
      -- \
      --jvm_flag=-Dbuild.number=${buildNumberMinor} \
      --jvm_flag=-Dintellij.build.target.os=current \
      --jvm_flag=-Dintellij.build.target.arch=current

    mv out/*/artifacts/*-no-jbr.tar.gz $out

    runHook postInstall
  '';

  env = {
    # TODO: remove in newer versions of idea-oss, where nested bazel isn't called or doesn't use java during fetch phase
    JAVA_HOME = jbr.home;
  };

  bazelRepoCacheFOD = {
    outputHash = bazelConfig.repoCacheFODHashes.${stdenv.hostPlatform.system};
    outputHashAlgo = "sha256";
  };

  passthru = {
    inherit
      version
      buildNumber
      libdbm
      fsnotifier
      ;
  };
}
