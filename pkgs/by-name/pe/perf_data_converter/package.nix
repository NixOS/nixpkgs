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
    rev = "ef34e6bfad5a6ab54080ddcc83a4d65849855e3a";
    hash = "sha256-PhacBegQDwWZqZeoZjoLR4akhVV3QrSPr1KflCuied0=";
  };
in
buildBazelPackage {
  pname = "perf_data_converter";
  version = "0-unstable-2024-10-14";

  src = fetchFromGitHub {
    owner = "google";
    repo = "perf_data_converter";
    rev = "f76cd4dd1e85bb54d60ea3fe69f92168fdf94edb";
    hash = "sha256-AScXL74K0Eiajdib56+7ay3K/MMWbmeUWkRWMaEJRC8=";
  };

  bazel = bazel_7;
  bazelFlags = [
    "--registry"
    "file://${registry}"
  ];

  fetchAttrs = {
    hash =
      {
        aarch64-linux = "sha256-Pm7iSGO3Ij3bbII/7oWqucTeg8cw6P/FV8/GMcTMyhQ=";
        x86_64-linux = "sha256-4JForyvjZmD9e3myRamt2N2PD4fImci50EEWc+1WxM8=";
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
    maintainers = with lib.maintainers; [ hzeller ];
    platforms = lib.platforms.linux;
  };
}
