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
  nix-update,
  writeShellApplication,
  curl,
  runCommand,
  jq,
}:

let
  # ccusage embeds the LiteLLM model-pricing table at build time instead of
  # downloading it (the Nix sandbox has no network). Upstream pins the exact
  # data revision via its flake.lock and points CCUSAGE_PRICING_JSON_PATH at it;
  # we mirror that revision here so the build is offline, reproducible, and
  # byte-identical to what upstream ships.
  #
  # Both values below are kept in sync with the package version by
  # passthru.updateScript — do not edit them by hand.
  litellmPricingRev = "f27df8d516802ce4c1b32973992154fe83b851cf";
  litellmPricingHash = "sha256-zJa6H2EwP9s+hMVs78Y+hwo4UX1dHRtvX5J3MdGh5aI=";
  litellmPricing = fetchurl {
    url = "https://raw.githubusercontent.com/BerriAI/litellm/${litellmPricingRev}/model_prices_and_context_window.json";
    hash = litellmPricingHash;
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ccusage";
  version = "20.0.6";

  src = fetchFromGitHub {
    owner = "ccusage";
    repo = "ccusage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uf/FlPprxx4jh74YwjmYMtoIHpTkKrWTLetbNoYiFv4=";
  };

  # The Cargo workspace lives in rust/, not at the repo root.
  cargoRoot = "rust";
  buildAndTestSubdir = "rust";

  cargoHash = "sha256-izA2Gs5nPmt0zn6/e1xM80vyyQHYKGEUDpUFRpyFiB8=";

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
    # Plain nix-update only refreshes version + src/cargo hashes; it can't know
    # about the LiteLLM pricing pin above. This wrapper bumps the package as
    # usual, then reads the litellm revision that ccusage locks at the new tag
    # and rewrites litellmPricingRev/litellmPricingHash to match, so automated
    # (r-ryantm) bumps stay complete instead of shipping stale pricing data.
    updateScript = lib.getExe (writeShellApplication {
      name = "ccusage-update";
      runtimeInputs = [
        curl
        jq
        nix-update
      ];
      text = ''
        set -euo pipefail

        attr="''${UPDATE_NIX_ATTR_PATH:-ccusage}"

        nix-update "$attr"

        version=$(nix-instantiate --eval --raw -A "$attr.version")
        rev=$(curl --fail --silent --show-error --location \
          "https://raw.githubusercontent.com/ccusage/ccusage/v''${version}/flake.lock" \
          | jq --raw-output '.nodes.litellm.locked.rev')
        hash=$(nix-prefetch-url --type sha256 \
          "https://raw.githubusercontent.com/BerriAI/litellm/''${rev}/model_prices_and_context_window.json" \
          | xargs nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri)

        file=$(nix-instantiate --eval --raw -A "$attr.meta.position" | sed -re 's/:[0-9]+$//')
        sed -i \
          -e "s|litellmPricingRev = \"[0-9a-f]*\"|litellmPricingRev = \"''${rev}\"|" \
          -e "s|litellmPricingHash = \"sha256-[^\"]*\"|litellmPricingHash = \"''${hash}\"|" \
          "$file"
      '';
    });

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
    homepage = "https://github.com/ccusage/ccusage";
    changelog = "https://github.com/ccusage/ccusage/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thrix ];
    mainProgram = "ccusage";
  };
})
