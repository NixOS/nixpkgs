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
    rev = "5036d290fe2a3b274747df8fe89660296c92a4a7";
    hash = "sha256-EwwlpsozuGJPI4BQVpj0po2WR6MhXEw6UJ8iazEUFqY=";
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
        aarch64-linux = "sha256-4r1PbylPxQScqFUNkr90AooVniF4Dq8TTV+pWupl1JA=";
        x86_64-linux = "sha256-20y5OEIIzhB3wd35aUdyVOR3YZU4So5RAJKOU6J90S0=";
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

  meta = with lib; {
    description = "Tool to convert Linux perf files to the profile.proto format used by pprof";
    homepage = "https://github.com/google/perf_data_converter";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hzeller ];
    platforms = platforms.linux;
  };
}
