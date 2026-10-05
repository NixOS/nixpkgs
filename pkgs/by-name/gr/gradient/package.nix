{
  lib,
  fetchFromGitHub,
  gitMinimal,
  gradient-nix,
  nixosTests,
  openssl,
  pkg-config,
  rustPlatform,
  zstd,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gradient";
  version = "2.0.0-rc.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "wavelens";
    repo = "gradient";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tqysnyuGnKFU4qZzjPeIlKpdrariNVH6G0fzTs+hr4s=";
  };

  sourceRoot = "${finalAttrs.src.name}/backend";

  cargoHash = "sha256-rTM7wnxfaTfu9V1vDaojiShF4Bku4bfgbfTNS1s1GWg=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    gitMinimal
    gradient-nix
    openssl
    zstd
  ];

  useNextest = true;
  checkFeatures = [ "gradient-daemon/mock" ];
  nativeCheckInputs = [ gitMinimal ];

  # These tests need a store fixture built from hello's `.drv` closure.
  cargoTestFlags = [
    "--filterset"
    "not (${
      lib.concatMapStringsSep " | " (test: "test(${test})") [
        "fakes::store_fixture::tests::"
        "test_eval_closure_walk_empty_store"
        "the_evaluators_are_released_before_the_closure_walk"
        "pushes_batch_closure_before_reporting_it"
        "a_known_dependency_is_neither_reported_nor_walked"
        "test_eval_aborts_when_signal_set_before_start"
        "abort_interrupts_a_running_nix_evaluation"
        "test_eval_dependencies_match_fixture"
      ]
    })"
  ];

  passthru.tests = { inherit (nixosTests) gradient; };

  meta = {
    description = "Nix-CI for Teams";
    homepage = "https://github.com/wavelens/gradient";
    changelog = "https://github.com/wavelens/gradient/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    teams = [ lib.teams.gradient ];
    platforms = lib.platforms.unix;
    mainProgram = "gradient-server";
  };
})
