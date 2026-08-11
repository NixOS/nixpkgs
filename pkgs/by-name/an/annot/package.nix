{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  jq,
  moreutils,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  cargo-tauri,
  pkg-config,
  wrapGAppsHook3,
  makeBinaryWrapper,
  git,
  jujutsu,

  libsoup_3,
  openssl,
  webkitgtk_4_1,

  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "annot";
  version = "0.19.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "denolehov";
    repo = "annot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T9CG5S0H90xYNP5QcbuINNEIEGLVCqR7HRX4XYNrgM4=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-OHsq/So4YhonxSnT4fByZnlPnpYvjcf0UuHHgBGVIf8=";
  };

  postPatch = ''
    jq '.bundle.createUpdaterArtifacts = false' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
  '';

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-F38w6rLm4VQ72p5DE/d92+vzy9ovX6P03r4Y+hGh7yc=";

  nativeBuildInputs = [
    jq
    moreutils
    pnpmConfigHook
    pnpm_10
    nodejs
    cargo-tauri.hook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeBinaryWrapper
  ];

  nativeCheckInputs = [
    git
    jujutsu
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      libsoup_3
      openssl
      webkitgtk_4_1
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      openssl
    ];

  # pnpmConfigHook runs with --ignore-scripts, so the postinstall that copies
  # Excalidraw fonts from node_modules into static/ must be run manually.
  preBuild = ''
    node scripts/copy-excalidraw-fonts.js
  '';

  # Disable automatic wrapper to handle it manually per platform
  dontWrapGApps = stdenv.hostPlatform.isLinux;

  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      wrapGApp "$out/bin/annot"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      makeWrapper "$out/Applications/annot.app/Contents/MacOS/annot" "$out/bin/annot"
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Human-in-the-loop annotation tool for AI workflows";
    longDescription = ''
      annot is an annotation tool for human-in-the-loop AI workflows. AI
      agents work fast, but vague feedback is a lossy channel. When an agent
      drafts a plan, proposes a refactor, or generates code, annot provides a
      moment of structured review: it opens a native window, you annotate
      specific lines with located, typed comments, then it closes and returns
      structured output to the agent.

      annot can be used as a standalone CLI (open a file, annotate, get
      output) or as an MCP server, allowing AI agents to block on human
      review mid-workflow. It supports reviewing files, diffs, and
      agent-generated content, with optional exit modes so the human can
      signal approval, rejection, or custom next steps.
    '';
    homepage = "https://github.com/denolehov/annot";
    license = lib.licenses.agpl3Only;
    mainProgram = "annot";
    maintainers = with lib.maintainers; [ fraggerfox ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
