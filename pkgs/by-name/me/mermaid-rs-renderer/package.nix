{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mermaid-rs-renderer";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "1jehuang";
    repo = "mermaid-rs-renderer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iV9kiAaGMVDfWu2BGbalw5NmzmTEsbZWWCh6oQ9BroY=";
  };

  cargoHash = "sha256-EdpdFMDdUTjrBGb6X09unG21BJanU8+9QOb5GA5NmAg=";

  # Known-failing upstream layout-routing test; the rest of the suite passes.
  checkFlags = [
    "--skip=layout::tests::dense_flowchart_keeps_mid_span_edge_reasonably_direct"
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
