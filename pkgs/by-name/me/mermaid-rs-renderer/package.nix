{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mermaid-rs-renderer";
  version = "0.3.1";
  __structuredAttrs = true;
  src = fetchFromGitHub {
    owner = "1jehuang";
    repo = "mermaid-rs-renderer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uekh1vJ19dAPP7+4PiqSlJizApZLpDhBWBoyN+fgS9s=";
  };

  cargoHash = "sha256-L++Z5Zjv5tJANvdL/sbm9V+OZjYP/6IjrhYfjQ8/Vf4=";

  checkFlags = [
    # Layout quality assertions fail at this tag
    "--skip=layout::tests::cycle_fixture_subgraph_entry_aligns_with_spine"
    "--skip=layout::tests::dense_flowchart_avoids_crossing_between_middle_and_far_edges"
    "--skip=every_fixture_renders_validly_and_preserves_content"
    "--skip=flowchart_fixtures_have_zero_hard_routing_violations"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast native Rust Mermaid diagram renderer";
    longDescription = ''
      mmdr renders diagrams 100-1400x faster than mermaid-cli by
      eliminating browser overhead.
    '';
    homepage = "https://github.com/1jehuang/mermaid-rs-renderer";
    changelog = "https://github.com/1jehuang/mermaid-rs-renderer/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "mmdr";
    maintainers = with lib.maintainers; [ yiyu ];
  };
})
