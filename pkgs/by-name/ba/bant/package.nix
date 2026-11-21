{
  lib,
  stdenv,
  buildBazelPackage,
  fetchFromGitHub,
  bazel_9,
  jdk,
  nix-update-script,
  cctools,
}:

let
  registry = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-central-registry";
    rev = "0aeaaaeee4bb913e21853a0ee0b935b2c114ae3f";
    hash = "sha256-OZjzzwO2+SmlhJvkTaW26gNvmZx0amCLF6e6MGJkRlI=";
  };
in
buildBazelPackage rec {
  pname = "bant";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "hzeller";
    repo = "bant";
    rev = "v${version}";
    hash = "sha256-AYjf4a5fKPEIQzFWGTDF2MGkVwZ5o7AP7I43whgcaMs=";
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

  fetchAttrs = {
    hash = "sha256-OYi9KrTBuQXLmAfrOxArEb168R0r/BqjIhNkCUCiyb8=";
  };

  nativeBuildInputs = [
    jdk
  ];
  bazel = bazel_9;

  bazelBuildFlags = [ "-c opt" ];
  bazelTestTargets = [ "//..." ];
  bazelTargets = [ "//bant:bant" ];

  buildAttrs = {
    installPhase = ''
      install -D --strip bazel-bin/bant/bant "$out/bin/bant"
    '';
  };

  passthru.updateScript = nix-update-script { };

  strictDeps = true;
  __structuredAttrs = true;

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
