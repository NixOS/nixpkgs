{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  jq,
  runCommand,
  writeText,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "merman-cli";
  version = "0.7.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Latias94";
    repo = "merman";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PzGHYRUlLjica0OTWcz4BwUJz0ci/FrOabkranOr9gU=";
  };

  cargoHash = "sha256-FKqDPDOBfePUby8rFBflLyhEBrHTbeGhNCdZviNnfts=";

  cargoBuildFlags = [ "--bin=merman-cli" ];

  checkFlags = [
    "--skip=rustdoc_outputs_inline_svg_for_mermaid_fence"
    "--skip=rustdoc_reexports_preserve_upstream_inline_svg"
    "--skip=svg_to_png_keeps_text_visible_when_requested_font_is_missing"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    tests =
      let
        flowchart = writeText "flowchart.mmd" ''
          flowchart TD
            A[Start] --> B{Decision}
            B -->|Yes| C[Do thing]
            B -->|No| D[Do other thing]
        '';
        flowchart-ascii = writeText "flowchart-ascii" ''
          +----------+
          |          |
          |  Start   |
          |          |
          +----------+
                |
                |
                |
                |
                v
          /----------\
          /          \
          < Decision |--------------+
          \          /              |
          \----------/              |
                |                   |
                |                  No
               Yes                  |
                |                   |
                v                   v
          +----------+     +----------------+
          |          |     |                |
          | Do thing |     | Do other thing |
          |          |     |                |
          +----------+     +----------------+
        '';
        merman-cli = lib.getExe finalAttrs.finalPackage;
      in
      {
        detect = runCommand "merman-cli-detect-test" { } ''
          ${merman-cli} detect ${flowchart} > $out
          [ "$(cat $out)" = "flowchart-v2" ]
        '';
        parse = runCommand "merman-cli-parse-test" { } ''
          ${merman-cli} parse ${flowchart} > $out
          [ "$(cat $out | ${lib.getExe jq} -r .type)" = "flowchart-v2" ]
        '';
        render-ascii = runCommand "merman-cli-render-ascii-test" { } ''
          ${merman-cli} render --format ascii ${flowchart} | sed 's/[[:space:]]*$//' > $out
          [ "$(cat $out)" = "$(cat ${flowchart-ascii})" ]
        '';
      };

    updateScript = nix-update-script {
      extraArgs = [ "--use-github-releases" ];
    };
  };

  meta = {
    description = "Parity-focused, headless Rust implementation of Mermaid.js";
    homepage = "https://github.com/Latias94/merman";
    changelog = "https://github.com/Latias94/merman/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    mainProgram = "merman-cli";
  };
})
