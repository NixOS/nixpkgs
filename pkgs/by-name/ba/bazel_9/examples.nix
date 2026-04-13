{
  fetchFromGitHub,
  lib,
  bazel_9,
  libgcc,
  cctools,
  stdenv,
  jdk_headless,
  callPackage,
  zlib,
  libxcrypt-legacy,
}:
let
  bazelPackage = callPackage ./build-support/bazelPackage.nix { };
  registry = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-central-registry";
    rev = "0e9e0cfdb88577300cc369d0cbe81e678d0fb271";
    sha256 = "sha256-YAR0tYVUdITfW/2H/LZky88nyoWTsgZf/CX4BtJ/Mwk=";
  };
  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "examples";
    rev = "2a8db5804341036b393ff7e1ba88edb30c8a82c7";
    sha256 = "sha256-/+rU73WPIKguoEOJDCodE3pUGSGju0VhixIcr0zBVmY=";
  };
  inherit (callPackage ./build-support/patching.nix { }) addFilePatch;
in
{
  java = bazelPackage {
    inherit src registry;
    sourceRoot = "source/java-tutorial";
    name = "java-tutorial";
    targets = [ "//:ProjectRunner" ];
    bazel = bazel_9;
    commandArgs = [
      "--extra_toolchains=@@rules_java++toolchains+local_jdk//:all"
      "--tool_java_runtime_version=local_jdk_21"
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin "--spawn_strategy=local";
    env = {
      JAVA_HOME = jdk_headless.home;
      USE_BAZEL_VERSION = bazel_9.version;
    };
    installPhase = ''
      mkdir $out
      cp bazel-bin/ProjectRunner.jar $out/
    '';
    buildInputs = [
      libgcc
      libxcrypt-legacy
      stdenv.cc.cc.lib
    ];
    nativeBuildInputs = lib.optional (stdenv.hostPlatform.isDarwin) cctools;
    patches = [
      ./patches/examples/java-tutorial.patch
      (addFilePatch {
        path = "b/rules_cc.patch";
        file = ./patches/examples/rules_cc.patch;
      })
    ];
    bazelVendorDepsFOD = {
      outputHash =
        {
          aarch64-darwin = "sha256-aNqtLlpYzz2lBJBHUOUDRkm0Cvd9tTnueNtFNQ8YN5M=";
          aarch64-linux = "sha256-PCTqHbxymG26fo7I9czoklECcB9EbSDk/gfVMuzQr2Y=";
          x86_64-darwin = "sha256-ZMIK/8UcBuG1vcHv5qkGwjynsLx4ZLeKcTyXiY2O2j4=";
          x86_64-linux = "sha256-jGFgm5OpcNIT30HPe7IQPIroT+7387PopCgXn6RonL0=";
        }
        .${stdenv.hostPlatform.system};
      outputHashAlgo = "sha256";
    };
  };
  cpp = bazelPackage {
    inherit src registry;
    sourceRoot = "source/cpp-tutorial/stage3";
    name = "cpp-tutorial";
    targets = [ "//main:hello-world" ];
    bazel = bazel_9;
    installPhase = ''
      mkdir $out
      cp bazel-bin/main/hello-world $out/
    '';
    nativeBuildInputs = lib.optional (stdenv.hostPlatform.isDarwin) cctools;
    commandArgs = lib.optionals (stdenv.hostPlatform.isDarwin) [
      "--host_cxxopt=-xc++"
      "--cxxopt=-xc++"
      "--spawn_strategy=local"
    ];
    env = {
      USE_BAZEL_VERSION = bazel_9.version;
    };
    patches = [
      ./patches/examples/cpp-tutorial.patch
      (addFilePatch {
        path = "b/rules_cc.patch";
        file = ./patches/examples/rules_cc.patch;
      })
    ];
    bazelRepoCacheFOD = {
      outputHash =
        {
          aarch64-darwin = "sha256-Yk+Y3XxlmE48RCYqmSfeBtElCGlVVdJvqRtuIMWbxrk=";
          aarch64-linux = "sha256-Yk+Y3XxlmE48RCYqmSfeBtElCGlVVdJvqRtuIMWbxrk=";
          x86_64-darwin = "sha256-Yk+Y3XxlmE48RCYqmSfeBtElCGlVVdJvqRtuIMWbxrk=";
          x86_64-linux = "sha256-Yk+Y3XxlmE48RCYqmSfeBtElCGlVVdJvqRtuIMWbxrk=";
        }
        .${stdenv.hostPlatform.system};
      outputHashAlgo = "sha256";
    };
  };
  rust = bazelPackage {
    inherit src registry;
    sourceRoot = "source/rust-examples/01-hello-world";
    name = "rust-examples-01-hello-world";
    targets = [ "//:bin" ];
    bazel = bazel_9;
    env = {
      USE_BAZEL_VERSION = bazel_9.version;
    };
    installPhase = ''
      mkdir $out
      cp bazel-bin/bin $out/hello-world
    '';
    buildInputs = [
      zlib
      libgcc
    ];
    nativeBuildInputs = lib.optional (stdenv.hostPlatform.isDarwin) cctools;
    commandArgs = lib.optional stdenv.hostPlatform.isDarwin "--spawn_strategy=local";
    autoPatchelfIgnoreMissingDeps = [ "librustc_driver-*.so" ];
    patches = [
      ./patches/examples/rust-examples.patch
      (addFilePatch {
        path = "b/rules_cc.patch";
        file = ./patches/examples/rules_cc.patch;
      })
    ];
    bazelVendorDepsFOD = {
      outputHash =
        {
          aarch64-darwin = "sha256-TfOAGMw2UDbZAM2zzxfhgSnCuGjb3fIABOPalzctFtE=";
          aarch64-linux = "sha256-A1cW9U2nYwbmqYNUNmLxWF+Xh0ZduLKzOUR4Hp6O8NU=";
          x86_64-darwin = "sha256-h3DjPeZvF2q1Y8khO0RwiayyU2YFneNmp2vHZRrEGS8=";
          x86_64-linux = "sha256-uKcfQBfw+Dkf3OS3yOlEBpPnn5mCxL89mpzXY5BkUqA=";
        }
        .${stdenv.hostPlatform.system};
      outputHashAlgo = "sha256";
    };
  };
}
