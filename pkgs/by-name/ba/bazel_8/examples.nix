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
    rev = "722299976c97e5191045c8016b7c8532189fc3f6";
    sha256 = "sha256-hi5BKI94am2LCXD93GBeT0gsODxGeSsd0OrhTwpNAgM=";
  };
  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "examples";
    rev = "9d6a2e67d29b8b6208d22d70cb22880345bb6803";
    sha256 = "sha256-NQqXsmX7hyTqLINkz1rnavx15jQTdIKpotw42rGc5mc=";
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
      outputHash =
        {
          aarch64-darwin = "sha256-FwHsg9P65Eu/n8PV7UW90bvBNG+U67zizRy6Krk32Yg=";
          aarch64-linux = "sha256-W8h2tCIauGnEvPpXje19bZUE/izHaCQ0Wj4nMaP3nkc=";
          x86_64-darwin = "sha256-XIrGRmYDDRN3Kkt1dFWex1bPRMeIHAR+XWLqB/PpOAM=";
          x86_64-linux = "sha256-VBckTQAK5qeyi2ublk+Dcga5O5XZg3bfHR6Yaw6vSp0=";
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
          aarch64-darwin = "sha256-l6qJU0zGIKl12TYYsG5b+upswUA0hGE+VtQ9QnKpBh8=";
          aarch64-linux = "sha256-l6qJU0zGIKl12TYYsG5b+upswUA0hGE+VtQ9QnKpBh8=";
          x86_64-darwin = "sha256-l6qJU0zGIKl12TYYsG5b+upswUA0hGE+VtQ9QnKpBh8=";
          x86_64-linux = "sha256-l6qJU0zGIKl12TYYsG5b+upswUA0hGE+VtQ9QnKpBh8=";
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
          aarch64-darwin = "sha256-D5bwW35QuLLhVE22FDyV9Nl8N7ULx71wCHbzB81+Xx0=";
          aarch64-linux = "sha256-F5X/cwtHR6sVFe1DzNDaEnGMIPR0SnXq2iIxhQeqIV8=";
          x86_64-darwin = "sha256-DXuPy68m3p6hlgEid7tpY8fGgvJWQTXth6h2kMSNFCc=";
          x86_64-linux = "sha256-oNLDccQ/XPg1Nl/9V14NdgiQsRoTvpaA6hyynMb414A=";
        }
        .${stdenv.hostPlatform.system};
      outputHashAlgo = "sha256";
    };
  };
}
