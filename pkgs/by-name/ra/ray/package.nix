{
  lib,
  fetchFromGitHub,
  buildBazelPackage,
  bazel_6,
  gitMinimal,
  # breakpointHook,
  nix-update-script,
}:

buildBazelPackage rec {
  pname = "ray";
  version = "2.44.1";

  src = fetchFromGitHub {
    owner = "ray-project";
    repo = "ray";
    rev = "ray-${version}";
    hash = "sha256-AwCa+RJTLZz7cGkg3g1Gwaldy6VPrXfleBr/ELmjq90=";
  };

  patches = [
    ./python.patch
  ];

  bazel = bazel_6;

  removeRulesCC = false;

  bazelTargets = [ "//cpp:ray_cpp_pkg" ];

  fetchAttrs = {
    nativeBuildInputs = [ gitMinimal ];
    hash = "sha256-HaUAIOtNbfmwy4I8BT5gAsRzMnF8x5a+N9GvzUZkL5g=";
  };

  buildAttrs = {
    installPhase = ''
      runHook preInstall

      cp -r python/ray/cpp "$out"

      runHook postInstall
    '';
    env.NIX_CFLAGS_COMPILE = "-Wno-error=dangling-reference";
  };

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Unified framework for scaling AI and Python applications";
    homepage = "https://github.com/ray-project/ray";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.linux;
  };
}
