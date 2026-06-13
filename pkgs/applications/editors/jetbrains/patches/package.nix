{
  bazel_8,
  binutils, coreutils,
  lib,
  bash,
  curl,
  cacert,
  stdenv,
  glibc,
  zlib,
  callPackage,
  replaceVars,
  fetchFromGitHub,
  jdk_headless,
  libxi,
  libxtst,
  alsa-lib,
  libxrender,
  libxcrypt-legacy,
  xz,
  ncurses,
  libxml2_13,
  libpanel,
  python3,
  breakpointHook,
}:

let
  bazelPackage = callPackage ../../ba/bazel_8/build-support/bazelPackage.nix { };
  inherit (callPackage ../../ba/bazel_8/build-support/patching.nix { }) addFilePatch;
  srcA = fetchFromGitHub {
    owner = "JetBrains";
    repo = "android";
    rev = "0cb3726fa10c2bfa19b6fa5fa65e10112056c17e"; # idea/2026.1
    sha256 = "sha256-xwxtfZPWTXnqDoonAuBG2xXedUbIOf7PFlbaUltJAuA=";
  };
  src = fetchFromGitHub {
    owner = "JetBrains";
    repo = "intellij-community";
    rev = "idea/2026.10f5a4dc177b4ca539e11b669959f7"; # idea/2026.1
    sha256 = "sha256-G8t0BJLbamkFpgGGYn35diEhCuGQtEw5QFUaVeWUXiI=";
  };
  registry = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-central-registry";
    rev = "53ab98c7cdc3d05be2239efe56a35367dcb6a091";
    sha256 = "sha256-LJ+LUex5zqi79Goku7ELlul286x8onZtIGNwcn7ZN5c=";
  };
  commandArgs = [
    "--lockfile_mode=off"
#    "--spawn_strategy=standalone" # TODO: investigate, something around /bin/sh in bazel sandbox?
    "--sandbox_debug" # TODO: remove
    "--verbose_failures"
    #"--incompatible_strict_action_env=false" # TODO: why is this needed for action_env to take effect?
    #"--action_env=LD_LIBRARY_PATH=${lib.makeLibraryPath [ zlib ]}"
    #"--action_env=PATH=${lib.makeBinPath [ binutils stdenv.cc bash coreutils ]}"
    # TODO: remove in newer versions of idea-oss, where nested bazel isn't called or doesn't use java during fetch phase
#    "--extra_toolchains=@@rules_java++toolchains+local_jdk//:all"
#    "--tool_java_runtime_version=local_jdk_21"
#    "--java_runtime_version=local_jdk_21"

    "--features=-module_maps" "--host_features=-module_maps"
#    "--cxxopt=-isystem"
#    "--cxxopt=${lib.getDev stdenv.cc.cc}/include/c++/v1"
#    "--host_cxxopt=-isystem"
#    "--host_cxxopt=${lib.getDev stdenv.cc.cc}/include/c++/v1"
  ];
in
bazelPackage {
  inherit src registry;
  inherit commandArgs;
  autoPatchelfIgnoreMissingDeps = [ "libpython3.10.so.1.0" ];
  bazel = bazel_8;
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
  targets = [
    "@community//build:i_build_target"
  ];
  name = "idea-oss-via-bazel";
  nativeBuildInputs = [
    stdenv.cc
    bash
    breakpointHook # TODO: remove
  ];
  postUnpack = ''
    ln -s ${srcA} "$sourceRoot/android"
  '';
  patches = [
    (replaceVars ./module.patch { sysroot = lib.getDev stdenv.cc.libc; })
    (addFilePatch {
      path = "b/build/rules_java_stub.patch";
      file = replaceVars ./rules_java_stub.patch { bash = lib.getExe bash; };
    })
    (addFilePatch {
      path = "b/platform/build-scripts/bazel/build/rules_java_stub.patch";
      file = replaceVars ./rules_java_stub.patch { bash = lib.getExe bash; };
    })
    ./cc.patch
    (addFilePatch {
      path = "b/build/cc_wrapper.patch";
      file = replaceVars ./cc_wrapper.patch { bash = lib.getExe bash; };
    })
    (addFilePatch {
      # TODO: remove with newer idea-oss not using nested bazel for fetch phase
      path = "b/platform/build-scripts/bazel/build/cc_wrapper.patch";
      file = replaceVars ./cc_wrapper.patch { bash = lib.getExe bash; };
    })
    #./llvm.patch
    (replaceVars ./bash.patch { bash = lib.getExe bash; })
    (replaceVars ./bazel.patch {
      bazel = lib.getExe bazel_8;
      commandArgs = lib.concatStringsSep " " (commandArgs ++ ["--registry=file://${registry}"]);
    })
  ];
  autoPatchelfVendorDirs = [
    "toolchains_llvm++llvm+llvm_toolchain_llvm"
    "rules_python++python+python_3_11_x86_64-unknown-linux-gnu"
    "rules_java++toolchains+remote_java_tools_linux"
    "+jbr_toolchains+remotejbr21_linux"
    "rules_java++toolchains+remotejdk25_linux"
  ];
  bazelPreBuild = ''
    # just in case there's no newline at the end of file
    echo >> platform/build-scripts/bazel/.bazelrc
    # covered by patch
    # echo "common ${builtins.concatStringsSep " " commandArgs}" >> platform/build-scripts/bazel/.bazelrc
    # echo "common --registry=file://${registry}" >> platform/build-scripts/bazel/.bazelrc

    # remote jdk won't work unpatched for repo fetching phase in nested bazel call
    echo "run --extra_toolchains=@@rules_java++toolchains+local_jdk//:all --tool_java_runtime_version=local_jdk_21 --java_runtime_version=local_jdk_21" >> platform/build-scripts/bazel/.bazelrc

    # TODO: tricky decision to make, for read flow nested bazel should see it, but for population flow
    #       there's 2 bazel invocations sharing those dirs - is it safe? Or at least when deps&patches&options are the same?
    # TODO: repo_cache&vendor_dir location being the same for read&populate flows might change in future?
    [ -d repo_cache ] && echo "common --repository_cache=../../../repo_cache" >> platform/build-scripts/bazel/.bazelrc
    [ -d vendor_dir ] && echo "common --vendor_dir=../../../vendor_dir" >> platform/build-scripts/bazel/.bazelrc
  '';
  installPhase = ''
    # TODO:
    # - export SOURCE_DATE_EPOCH=1775948377 or some other recent time to make installer happy, or patch it
    # - apply bazel options, maybe create a helper for that and/or set via helper bazelrc file in general
    # - fix downloading of extra artifacts by installer
    # - nix patching for downloaded artifacts
    # - select os&arch? Or maybe auto works ok?
    ${bazel_8}/bin/bazel run --registry=file://${registry} --repository_cache=repo_cache --vendor_dir=vendor_dir ${builtins.concatStringsSep " " commandArgs} @community//build:i_build_target -- -Dintellij.build.target.os=linux -Dintellij.build.target.arch=x64 intellij_community
    # TODO: collect the results
    mkdir -p $out
    cp -r idea-oss $out/
  '';
  env = {
    USE_BAZEL_VERSION = bazel_8.version;
    # TODO: remove in newer versions of idea-oss, where nested bazel isn't called or doesn't use java during fetch phase
    JAVA_HOME = jdk_headless.home;
  };
  bazelRepoCacheFOD = {
    outputHash =
      {
        x86_64-linux = "sha256-EVsuIUj8rCBEkk6ZIAjEiRvJ9N7LVwxzBVtOv/OiFxU=";
      }
      .${stdenv.hostPlatform.system};
    outputHashAlgo = "sha256";
  };
}
