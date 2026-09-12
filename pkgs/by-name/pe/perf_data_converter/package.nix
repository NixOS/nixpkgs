{
  lib,
  stdenv,
  buildBazelPackage,
  fetchFromGitHub,
  bazel_7,
  jdk,
  elfutils,
  libcap,
}:

let
  system = stdenv.hostPlatform.system;
  registry = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-central-registry";
    rev = "6d7a78e3bb927a52e3e2a5087729f9136d35c084";
    hash = "sha256-qH4MYS12oKni1JMtZEm7KEpK68CSr3/45aWGmxaydEE=";
  };
in
buildBazelPackage {
  pname = "perf_data_converter";
  version = "0-unstable-2026-09-02";

  src = fetchFromGitHub {
    owner = "google";
    repo = "perf_data_converter";
    rev = "d4ea56c0c9c0c3f197e26a0161a5a0d9580d5ba7";
    hash = "sha256-qimXlAB4mk7TagnHWG2n+4aRX1fhtisSXFhbNvQw4UI=";
  };

  bazel = bazel_7;
  bazelFlags = [
    "--registry"
    "file://${registry}"
  ];

  fetchAttrs = {
    preInstall = ''
      rm -rf $bazelOut/external/rules_shell~~sh_configure~local_config_shell
    '';
    hash =
      {
        aarch64-linux = "sha256-pcbfXO+6MC/eI+OemDIUFH3o+3Vr6+YWeH36xuZpqd8=";
        x86_64-linux = "sha256-WcfZxiSKKUi98TjAviqsb4E1QPKa3Hg7RvxR3kXV2QM=";
      }
      .${system} or (throw "No hash for system: ${system}");
  };

  nativeBuildInputs = [ jdk ];

  buildInputs = [
    elfutils
    libcap
  ];

  removeRulesCC = false;

  bazelBuildFlags = [ "-c opt" ];
  bazelTargets = [ "src:perf_to_profile" ];

  doCheck = true;
  bazelTestTargets = [ "src:all" ];

  buildAttrs = {
    installPhase = ''
      runHook preInstall
      install -Dm555 -t "$out/bin" bazel-bin/src/perf_to_profile
      runHook postInstall
    '';
  };

  meta = {
    description = "Tool to convert Linux perf files to the profile.proto format used by pprof";
    homepage = "https://github.com/google/perf_data_converter";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      hzeller
      lromor
    ];
    platforms = lib.platforms.linux;
  };
}
