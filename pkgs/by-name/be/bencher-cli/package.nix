{
  lib,
  fetchFromGitHub,
  rustPlatform,
  mold,
  nix-update-script,
  versionCheckHook,
  rustc,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bencher-cli";
  version = "0.6.12";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "bencherdev";
    repo = "bencher";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7tM35WsQfnGj/xLj8/GICsd6gELh82LP+aCwXLM9byA=";
  };

  cargoHash = "sha256-EuRobN0g/3iA8YqrrMV5O3WfZHNVWW6yaO6esY/uXOU=";

  nativeBuildInputs = [ mold ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  cargoBuildFlags = [ "--package=bencher_cli" ];
  cargoTestFlags = [ "--package=bencher_cli" ];
  # Build the open-source version
  buildNoDefaultFeatures = true;
  checkNoDefaultFeatures = finalAttrs.buildNoDefaultFeatures;

  postPatch = lib.optionalString finalAttrs.buildNoDefaultFeatures ''
    # Replaces the proprietary Rust files with empty files
    # This is just a safeguard, the build shouldn't touch these files anyways
    echo "find . -path '*/plus/*' -type f ! -name Cargo.toml -exec truncate -s 0 {} +"
    find . -path '*/plus/*' -type f ! -name Cargo.toml -exec truncate -s 0 {} +
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-Line interface for the Bencher continuous benchmarking platform";
    mainProgram = "bencher";
    longDescription = ''
      Bencher is a suite of continuous benchmarking tools.
      Bencher allows you to detect and prevent performance regressions
      *before* they hit production.

      - Run: Run your benchmarks locally or in CI using your favorite
        benchmarking tools. The bencher CLI simply wraps your existing
        benchmark harness and stores its results.
      - Track: Track the results of your benchmarks over time. Monitor, query,
        and graph the results using the Bencher web console based on the source
        branch, testbed, benchmark, and measure.
      - Catch: Catch performance regressions in CI. Bencher uses state of the
        art, customizable analytics to detect performance regressions before
        they make it to production.

      Bencher's source repo includes non-free features, included in the build
      as the Cargo feature "plus".
      Files in the plus directories are proprietary, while the other files
      are dual Apache-2.0/MIT licensed.
      The Nix derivation does not compile the proprietary features.
    '';
    homepage = "https://bencher.dev";
    changelog = "https://github.com/bencherdev/bencher/releases/tag/v${finalAttrs.version}";
    license =
      if finalAttrs.buildNoDefaultFeatures then
        lib.licenses.OR [
          lib.licenses.asl20
          lib.licenses.mit
        ]
      else
        lib.licenses.unfree;
    platforms = rustc.meta.platforms;
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
