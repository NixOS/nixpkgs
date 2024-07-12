{
  lib,
  buildBazelPackage,
  fetchFromGitHub,
  bazel_6,
  jdk,
  elfutils,
  libcap,
}:

buildBazelPackage rec {
  pname = "perf_data_converter";
  version = "0-unstable-2024-03-12";

  src = fetchFromGitHub {
    owner = "google";
    repo = "perf_data_converter";
    rev = "e1cfe1e7e5d8cf3b728a166bf02d4227c82801eb";
    hash = "sha256-Y3tBLH2jf1f28o6RK2inq9FulKc66qcqwKmxYdFC5tA=";
  };

  bazel = bazel_6;
  bazelFlags = [
    "--java_runtime_version=local_jdk"
    "--tool_java_runtime_version=local_jdk"
  ];

  fetchAttrs = {
    sha256 = "sha256-Qm6Ng9cXvKx043P7qyNHyyMvdGK9aNarX1ZKeCp3mgY=";
  };

  nativeBuildInputs = [ jdk ];

  buildInputs = [
    elfutils
    libcap
  ];

  removeRulesCC = false;

  bazelBuildFlags = [ "-c opt" ];
  bazelTargets = [ "src:perf_to_profile" ];

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
