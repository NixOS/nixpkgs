{
  lib,
  stdenv,
  buildBazelPackage,
  fetchFromGitHub,
  bazel_7,
  jdk,
  nix-update-script,
  cctools,
}:

let
  system = stdenv.hostPlatform.system;
  registry = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-central-registry";
    rev = "1f55d91e1be0e4863a698b9d7582cf097ad456ee";
    hash = "sha256-ESHF5FhLvn4u4j//6AFiSJRJYSKrI4EKr4oDwvsrcPM=";
  };
in
buildBazelPackage rec {
  pname = "bant";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "hzeller";
    repo = "bant";
    rev = "v${version}";
    hash = "sha256-0RWR793+qXc5QYIc7wIL323iDkNts9w4e90FCdHT6t4=";
  };

  bazelFlags = [
    "--registry"
    "file://${registry}"
  ];
  LIBTOOL = lib.optionalString stdenv.hostPlatform.isDarwin "${cctools}/bin/libtool";

  postPatch = ''
    patchShebangs scripts/create-workspace-status.sh
  '';

  removeRulesCC = false;

  fetchAttrs = {
    hash =
      {
        aarch64-linux = "sha256-IVih5EJAFPkuWxAvkZs+leLj/YehQyvvkbyBV81kvDA=";
        x86_64-linux = "sha256-zSS5jCvTMXVhBkj9hlvpSP4bCmnZl3SqD68mlseNYIs=";
      }
      .${system} or (throw "No hash for system: ${system}");
  };

  nativeBuildInputs = [
    jdk
  ];
  bazel = bazel_7;

  bazelBuildFlags = [ "-c opt" ];
  bazelTestTargets = [ "//..." ];
  bazelTargets = [ "//bant:bant" ];

  buildAttrs = {
    installPhase = ''
      install -D --strip bazel-bin/bant/bant "$out/bin/bant"
    '';
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bazel/Build Analysis and Navigation Tool";
    homepage = "http://bant.build/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      hzeller
      lromor
    ];
  };
}
