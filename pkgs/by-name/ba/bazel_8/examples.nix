{
  fetchFromGitHub,
  lib,
  bazel_8,
  libgcc,
  cctools,
  stdenv,
  jdk_headless,
  callPackage,
  zlib,
}:
let
  bazelPackage = callPackage ./build-support/bazelPackage.nix { };
  registry = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-central-registry";
    rev = "9342d3ec42ebafc2c06c33aa9d83b25ed984ebb1";
    sha256 = "sha256-VT63Y8w9BawBXl5xgujG4Gv3SEGbUADGVsNPdUoDvsY=";
  };
  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "examples";
    rev = "568db753be213cc4be6c599e54ca64061ddbe6da";
    sha256 = "sha256-F+iKi82uGWmJ+ICpITePdsA1SkncavSdgLkOKMr5LwM=";
  };
in
{
  java = bazelPackage {
    inherit src registry;
    sourceRoot = "source/java-tutorial";
    name = "java-tutorial";
    targets = [ "//:ProjectRunner" ];
    bazel = bazel_8;
    commandArgs = [
      "--extra_toolchains=@@rules_java++toolchains+local_jdk//:all"
      "--tool_java_runtime_version=local_jdk_21"
    ];
    env = {
      JAVA_HOME = jdk_headless.home;
      USE_BAZEL_VERSION = bazel_8.version;
    };
    installPhase = ''
      mkdir $out
      cp bazel-bin/ProjectRunner.jar $out/
    '';
    nativeBuildInputs = lib.optional (stdenv.hostPlatform.isDarwin) cctools;
    bazelRepoCacheFOD = {
      outputHash = lib.attrsets.attrByPath [ stdenv.hostPlatform.system ] null {
        x86_64-linux = "sha256-64Ze+t0UYR2qQNECWes27SjzdkP+z5eJsCAO+OR+h/o=";
        x86_64-darwin = lib.fakeHash;
        aarch64-linux = "sha256-vEcOTdJM2YYle3PijKwroyM7LpfyK/3k/egRKDbjsmU=";
        aarch64-darwin = "sha256-ya85EJikYXWpjtlgNu7i0DqtACgZBsppGEv3SVoJ6JA=";
      };
      outputHashAlgo = "sha256";
    };
  };
  cpp = bazelPackage {
    inherit src registry;
    sourceRoot = "source/cpp-tutorial/stage3";
    name = "cpp-tutorial";
    targets = [ "//main:hello-world" ];
    bazel = bazel_8;
    installPhase = ''
      mkdir $out
      cp bazel-bin/main/hello-world $out/
    '';
    nativeBuildInputs = lib.optional (stdenv.hostPlatform.isDarwin) cctools;
    commandArgs = lib.optionals (stdenv.hostPlatform.isDarwin) [
      "--host_cxxopt=-xc++"
      "--cxxopt=-xc++"
    ];
    env = {
      USE_BAZEL_VERSION = bazel_8.version;
    };
    bazelRepoCacheFOD = {
      outputHash =
        {
          x86_64-linux = "sha256-oPPWQdflAPMxF9YPazC//r0R3Sh6fUmNQe0oLM5EBUI=";
          aarch64-linux = "sha256-oPPWQdflAPMxF9YPazC//r0R3Sh6fUmNQe0oLM5EBUI=";
          aarch64-darwin = "sha256-oPPWQdflAPMxF9YPazC//r0R3Sh6fUmNQe0oLM5EBUI=";
          x86_64-darwin = lib.fakeHash;
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
    bazel = bazel_8;
    env = {
      USE_BAZEL_VERSION = bazel_8.version;
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
    autoPatchelfIgnoreMissingDeps = [ "librustc_driver-*.so" ];
    bazelVendorDepsFOD = {
      outputHash =
        {
          aarch64-linux = "sha256-2xopm/OCg9A1LqoW1ZesQc5pF/vX0ToIj1JYMtweVR0=";
          x86_64-linux = "sha256-v987hMC6w2Lwr/PZn2zGHhHmXzecI2koLjOmGz0Mzng=";
          aarch64-darwin = "sha256-sS7PzLI44dX7P0PY/68YjRSDkNJ6w5BklJNsXPHuOPc=";
          x86_64-darwin = lib.fakeHash;
        }
        .${stdenv.hostPlatform.system};
      outputHashAlgo = "sha256";
    };
  };
}
