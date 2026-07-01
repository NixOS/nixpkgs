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
  libxi,
  libxtst,
  alsa-lib,
  libxrender,
  libxcrypt-legacy,
}:
let
  bazelPackage = callPackage ./build-support/bazelPackage.nix { };
  registry = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-central-registry";
    rev = "5b592bb7e0cf107a2680a417db97db52bcd1afa3";
    sha256 = "sha256-Qn4KKZr5qY16XZWMaDc3YUywzj4YXE0qh2oleGtsP44=";
  };
  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "examples";
    rev = "daadf13928d9e091ff0c26ce53aea3099a8fc6a3";
    sha256 = "sha256-ekX3TWwAbE/oFpfejLKyiJS1JfgYNZAn9n2k0V2W12Q=";
  };
in
{
  java = bazelPackage {
    inherit src registry;
    sourceRoot = "source/java-tutorial";
    name = "java-tutorial";
    targets = [
      "//:ProjectRunner"
      "@@rules_java+//toolchains:platformclasspath"
    ];
    autoPatchelfVendorDirs = [
      "rules_java++toolchains+remotejdk11_linux"
      "rules_java++toolchains+remotejdk21_linux"
    ];
    bazel = bazel_8;
    buildInputs = lib.optional (stdenv.hostPlatform.isLinux) [
      zlib
      stdenv.cc.cc
      libxi
      libxtst
      alsa-lib
      libxrender
      libxcrypt-legacy
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
      outputHash =
        {
          aarch64-darwin = "sha256-PpPOAD2dGGzcp9iYYyojVb+7hz7MxehPrhHkLtN9/+k=";
          aarch64-linux = "sha256-UZTMZXRhaIwGxF8MEKT7DWkhEayfoBA8tZ/iCksFaks=";
          x86_64-darwin = "sha256-XOcf0p/IwGjS1EmTyIX+P8UJNggs715R7MymF4XlDtc=";
          x86_64-linux = "sha256-R7wuLuV9KYWo2tTmVtYtuW0Hr5Q4b+WbSFbNG7iW9hc=";
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
          aarch64-darwin = "sha256-jFZX2FYuhj9OAOkH2jLXAdDHBP/baxeqZzg6dPH+vGI=";
          aarch64-linux = "sha256-jFZX2FYuhj9OAOkH2jLXAdDHBP/baxeqZzg6dPH+vGI=";
          x86_64-darwin = "sha256-jFZX2FYuhj9OAOkH2jLXAdDHBP/baxeqZzg6dPH+vGI=";
          x86_64-linux = "sha256-jFZX2FYuhj9OAOkH2jLXAdDHBP/baxeqZzg6dPH+vGI=";
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
    bazelRepoCacheFOD = {
      outputHash =
        {
          aarch64-darwin = "sha256-eMGz1DpQuA33lRe9RyvbGZUXL1sLUUd/r6w2W+Nl6HI=";
          aarch64-linux = " sha256-ruz7i2JLQHOU9bfwlCyKv8qOsJjUeEK8LXwBl+4XtO8=";
          x86_64-darwin = "sha256-9uPoSyWgwZF/jLoM1NscEqqYlfXDkVbpK/Ve2VNElAc=";
          x86_64-linux = "sha256-dcDCZYMByMBdAXhvgu8EkP4f1bqMvSiMsA+0F3ShIaw=";
        }
        .${stdenv.hostPlatform.system};
      outputHashAlgo = "sha256";
    };
  };
}
