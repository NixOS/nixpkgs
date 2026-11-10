{
  lib,
  stdenv,
  buildBazelPackage,
  fetchFromGitHub,
  bazel_9,
  jdk,
  elfutils,
  libcap,
}:

let
  system = stdenv.hostPlatform.system;
  registry = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-central-registry";
    rev = "0aeaaaeee4bb913e21853a0ee0b935b2c114ae3f";
    hash = "sha256-OZjzzwO2+SmlhJvkTaW26gNvmZx0amCLF6e6MGJkRlI=";
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

  bazel = bazel_9;
  bazelFlags = [
    "--registry"
    "file://${registry}"
  ];

  fetchAttrs = {
    hash = "sha256-aiKFVuOWi9/Ex+7+2L0Sb8ac9tqqVc4zRW+fLjOHtWI=";
  };

  nativeBuildInputs = [ jdk ];

  buildInputs = [
    elfutils
    libcap
  ];

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
