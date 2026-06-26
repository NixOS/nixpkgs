{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchurl,
  pkg-config,
  apple-sdk_15,
  libiconv,
  versionCheckHook,
  nix-update-script,
  runCommand,
  jq,
}:

let
  # ccusage embeds the LiteLLM model-pricing table at build time. Its build
  # script otherwise downloads this file from the network, which fails in the
  # sandbox. Upstream pins the data via a flake input and points
  # CCUSAGE_PRICING_JSON_PATH at it; mirror that exact revision here so the
  # build is offline and reproducible (see package.nix + flake.lock in the
  # upstream repo at tag v20.0.6). Bump this revision together with the package
  # version; nix-update only refreshes the src and cargo hashes.
  litellmPricing = fetchurl {
    url = "https://raw.githubusercontent.com/BerriAI/litellm/f27df8d516802ce4c1b32973992154fe83b851cf/model_prices_and_context_window.json";
    hash = "sha256-zJa6H2EwP9s+hMVs78Y+hwo4UX1dHRtvX5J3MdGh5aI=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ccusage";
  version = "20.0.14";

  src = fetchFromGitHub {
    owner = "ryoppippi";
    repo = "ccusage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KtN0dJ183W9i9y+eyLl95WKXrtu7uF0D/sN6/hu6Sr4=";
  };

  # The Cargo workspace lives in rust/, not at the repo root.
  cargoRoot = "rust";
  buildAndTestSubdir = "rust";

  cargoHash = "sha256-h3qXDzIu7Qv7/OnaVH9Fz3a3ZTChNS5JcaiHe/XG2eE=";

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
    libiconv
  ];

  env.CCUSAGE_PRICING_JSON_PATH = "${litellmPricing}";

  # Build only the ccusage binary out of the multi-crate workspace.
  cargoBuildFlags = [
    "-p"
    "ccusage"
    "--bin"
    "ccusage"
  ];

  # Upstream disables the test suite in its own Nix build; parts of it rely on
  # network access and live pricing data. versionCheckHook still exercises the
  # built binary below.
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };

    tests = {
      # With no agent data on disk, ccusage must still emit a valid, empty JSON
      # report. --offline keeps it from reaching the network, exercising the
      # pricing table baked in at build time. This guards the data discovery,
      # JSON serialization, and offline-pricing paths without needing fixtures.
      smoke =
        runCommand "ccusage-smoke-test"
          {
            nativeBuildInputs = [
              finalAttrs.finalPackage
              jq
            ];
          }
          ''
            export HOME="$(mktemp -d)"
            ccusage daily --json --offline > report.json
            jq -e '.daily == [] and .totals.totalTokens == 0' report.json
            touch "$out"
          '';
    };
  };

  meta = {
    description = "Analyze coding agent CLI token usage and costs from local data";
    homepage = "https://github.com/ryoppippi/ccusage";
    changelog = "https://github.com/ryoppippi/ccusage/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thrix ];
    mainProgram = "ccusage";
  };
})
