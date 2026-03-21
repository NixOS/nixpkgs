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
    rev = "dc643526b97838ffe421b833dd8b9c95e71702e8";
    hash = "sha256-SLtrNU5uEt8rRJDUdV/IaI37CujsTHLlE31l2zYoRss=";
  };
in
buildBazelPackage rec {
  pname = "bant";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "hzeller";
    repo = "bant";
    rev = "v${version}";
    hash = "sha256-qS2oKQ9/vNX58PftEjHD+3ApXtWL90YVBHnifLtDTcU=";
  };

  bazelFlags = [
    "--registry"
    "file://${registry}"
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    LIBTOOL = "${cctools}/bin/libtool";
  };

  postPatch = ''
    patchShebangs scripts/create-workspace-status.sh
  '';

  removeRulesCC = false;

  fetchAttrs = {
    preInstall = ''
      rm -rf $bazelOut/external/rules_shell~~sh_configure~local_config_shell
    '';
    hash =
      {
        aarch64-linux = "sha256-E70F3D7HGsyV0bPd0zbRTytx1UCHyEuNKObaG2eRy8A=";
        x86_64-linux = "sha256-E9XAKrt16DOAne3/wY9PwWIM61YX0fWs8x1hqF3YJSU=";
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
