{
  lib,
  stdenv,
  fetchurl,
  bun,
  makeWrapper,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "context-mode";
  version = "1.0.143";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://registry.npmjs.org/context-mode/-/context-mode-${finalAttrs.version}.tgz";
    hash = "sha256-Qh91ZkeLN11ACg4y1lUpeDbSkTWF8QkY/oWKiHR/+og=";
  };

  sourceRoot = "package";

  nativeBuildInputs = [
    makeWrapper
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/context-mode
    cp -r \
      "$NIX_BUILD_TOP/$sourceRoot/server.bundle.mjs" \
      "$NIX_BUILD_TOP/$sourceRoot/cli.bundle.mjs" \
      "$NIX_BUILD_TOP/$sourceRoot/package.json" \
      "$NIX_BUILD_TOP/$sourceRoot/.claude-plugin" \
      "$NIX_BUILD_TOP/$sourceRoot/.codex-plugin" \
      "$NIX_BUILD_TOP/$sourceRoot/bin" \
      "$NIX_BUILD_TOP/$sourceRoot/configs" \
      "$NIX_BUILD_TOP/$sourceRoot/hooks" \
      "$NIX_BUILD_TOP/$sourceRoot/insight" \
      "$NIX_BUILD_TOP/$sourceRoot/scripts" \
      "$NIX_BUILD_TOP/$sourceRoot/skills" \
      $out/lib/context-mode/

    mkdir -p $out/bin
    # Use bun as the runtime so globalThis.Bun is set at startup, which causes
    # db-base.js to use bun:sqlite instead of better-sqlite3 (unavailable in
    # nixpkgs). The server.bundle.mjs shebang says "node" but we override here.
    # Prepend bun to PATH so the server's runtime detection finds it and avoids
    # printing a spurious "Install Bun" performance tip.
    makeWrapper ${bun}/bin/bun $out/bin/context-mode \
      --add-flags "$out/lib/context-mode/server.bundle.mjs" \
      --prefix PATH : ${lib.makeBinPath [ bun ]}

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Context window optimization MCP server for AI coding agents";
    homepage = "https://github.com/mksglu/context-mode";
    license = lib.licenses.elastic20;
    maintainers = with lib.maintainers; [ eana ];
    mainProgram = "context-mode";
  };
})
