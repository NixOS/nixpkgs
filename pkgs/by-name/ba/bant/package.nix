{
  lib,
  stdenv,
  buildBazelPackage,
  fetchFromGitHub,
  bazel_6,
  jdk,
  nix-update-script,
}:

let
  system = stdenv.hostPlatform.system;
  registry = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-central-registry";
    rev = "40bc9ad53e5a59d596935839e7c072679e706266";
    hash = "sha256-CL0YMQd1ck6/dlvJCLxt9jYyqDuk+iAWfdBOMj864u8=";
  };
in
buildBazelPackage rec {
  pname = "bant";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "hzeller";
    repo = "bant";
    rev = "v${version}";
    hash = "sha256-CMqh2v6Y/jvrDC2M4Q+pC0FkNJ95gbGTR1UC6zviwV4=";
  };

  bazelFlags = [
    "--registry"
    "file://${registry}"
  ];

  postPatch = ''
    patchShebangs scripts/create-workspace-status.sh
  '';

  fetchAttrs = {
    hash =
      {
        aarch64-linux = "sha256-E4VHjDa0qkHmKUNpTBfJi7dhMLcd1z5he+p31/XvUl8=";
        x86_64-linux = "sha256-M7xhAIhTcVLCUkmy4giGxbr7DgHrXbg0e8D/bL6yZWU=";
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
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      hzeller
      lromor
    ];
    platforms = lib.platforms.linux;
  };
}
