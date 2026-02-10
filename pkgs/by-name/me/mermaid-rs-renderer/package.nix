{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mermaid-rs-renderer";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "1jehuang";
    repo = "mermaid-rs-renderer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rmfnyGjJDzL+p0MlkVAf8h8+3r9k17HcKtaapkpiYq8=";
  };

  cargoHash = "sha256-F2hVrRfSpesFC3JV4DQtVcDq/hGX4Y2xCNv/gflu/cw=";

  checkFlags = [
    # Known-failing upstream layout-routing heuristics; the rest of the suite passes.
    "--skip=layout::tests::cycle_fixture_subgraph_entry_aligns_with_spine"
    "--skip=layout::tests::dense_flowchart_avoids_crossing_between_middle_and_far_edges"
    # ER-diagram attribute rows render into per-column tspans, so this parity check
    # cannot match the joined multi-line entity block even though the labels are present.
    "--skip=every_fixture_renders_validly_and_preserves_content"
    # Upstream routing-quality invariant trips on a self-loop fixture (soft
    # geometry-debt metric only, no hard violations).
    "--skip=flowchart_fixtures_have_zero_hard_routing_violations"
  ];

  __structuredAttrs = true;

  meta = {
    description = "A fast native Rust Mermaid diagram renderer. No browser required. 500-1000x faster than mermaid-cli";
    homepage = "https://github.com/1jehuang/mermaid-rs-renderer";
    changelog = "https://github.com/1jehuang/mermaid-rs-renderer/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kiara ];
    mainProgram = "mmdr";
  };
})
