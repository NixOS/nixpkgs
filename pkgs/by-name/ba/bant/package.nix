{
  lib,
  stdenv,
  buildBazelPackage,
  fetchFromGitHub,
  bazel_6,
  jdk,
  nix-update-script,
  cctools,
}:

let
  system = stdenv.hostPlatform.system;
  registry = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-central-registry";
    rev = "b03f4f95d8ba67873843eae80a73fef8ebf1522e";
    hash = "sha256-gJr5bJ6Kj7jiUhnCC+YOUh3ChFR/55eUbwpP2srsVvM=";
  };
in
buildBazelPackage rec {
  pname = "bant";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "hzeller";
    repo = "bant";
    rev = "v${version}";
    hash = "sha256-xiTi4GrCeoI8hIEgYMAdzUPvJzYvXrvbo6MBq9my5Cw=";
  };

  bazelFlags = [
    "--registry"
    "file://${registry}"
  ];
  LIBTOOL = lib.optionalString stdenv.hostPlatform.isDarwin "${cctools}/bin/libtool";

  postPatch = ''
    patchShebangs scripts/create-workspace-status.sh
  '';

  fetchAttrs = {
    hash =
      {
        aarch64-linux = "sha256-ibv49Y0VjAvfTUwxRUH4BmzUvz8J/qfYPGnI5Tw51HA=";
        x86_64-linux = "sha256-VHR08FB4G0LlczWtBb8AdU5tNEzBDNUZpHoB6e3HB1M=";
        aarch64-darwin = "sha256-5uKCLDJs0tzOJ7YiKP90RIfIYrken3XFyhT5HHdzft0=";
      }
      .${system} or (throw "No hash for system: ${system}");
  };

  nativeBuildInputs = [
    jdk
  ];
  bazel = bazel_6;

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
