{
  lib,
  stdenv,
  fetchurl,
  bun,
  gnutar,
  installAgentSkills,
  makeWrapper,
  nix-update-script,
  _experimental-update-script-combinators,
}:

# build/adapters/opencode/plugin.js (package.json main/exports) is unbundled
# ESM needing a node_modules dir the npm tarball lacks. Two shims below make it
# load: build/server.js becomes a re-export of server.bundle.mjs (avoids
# resolving @modelcontextprotocol/sdk), only zod stays vendored for real.
#
# zod is pinned as passthru.zod (not a plain let-binding) and synced by
# ./update-zod.sh, so `nix-update context-mode` refreshes both the version
# and the hash unattended - see updateScript below.
# TODO: drop the zod pin and the two shims once context-mode bundles its
# opencode plugin entry as a function export.
stdenv.mkDerivation (finalAttrs: {
  pname = "context-mode";
  version = "1.0.169";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://registry.npmjs.org/context-mode/-/context-mode-${finalAttrs.version}.tgz";
    hash = "sha256-CcQeTPd7IVZsdrjqL9vX89gjBV/uLwLCFm/Vu1ddryw=";
  };

  sourceRoot = "package";

  nativeBuildInputs = [
    gnutar
    installAgentSkills
    makeWrapper
  ];

  dontBuild = true;

  # HACK: auto-glob installs every **/SKILL.md, hitting duplicate "context-mode"
  # skills under configs/*/skills/ (other agents' bundles) and hard-failing the
  # build. Scoped manually to skills/*/ below instead.
  # TODO: drop this and the loop if the setup hook gains an exclusion, or
  # context-mode stops shipping the duplicates.
  dontInstallAgentSkills = 1;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/context-mode
    cp -r \
      .claude-plugin \
      .codex-plugin \
      .openclaw-plugin \
      build \
      server.bundle.mjs \
      cli.bundle.mjs \
      package.json \
      openclaw.plugin.json \
      LICENSE \
      README.md \
      bin \
      configs \
      hooks \
      scripts \
      skills \
      $out/lib/context-mode/

    # server.bundle.mjs is the bundled build of build/server.js (sdk/ajv
    # inlined, only node: builtins imported) - re-export it instead of
    # resolving the sdk tree.
    echo 'export * from "../server.bundle.mjs";' \
      > $out/lib/context-mode/build/server.js

    # Defensive: opencode's file-path plugin loader is documented as calling
    # the default export as a function; context-mode's export is { id, server }.
    # Not reproduced in isolated testing (both shapes loaded fine), but the
    # wrapper is a harmless no-op if so, and a real fix if some build needs it.
    # TODO: drop once confirmed unnecessary, or context-mode exports a function.
    cat > $out/lib/context-mode/build/adapters/opencode/plugin-function.mjs <<'EOF'
    import plugin from "./plugin.js";

    export default async (input) => plugin.server(input);
    EOF

    # zod is the plugin's one remaining bare import (zod3tov4.js). Bun
    # resolves it by walking up from the importing file, so a node_modules
    # dir beside build/ suffices; unpacked rather than symlinked since
    # fetchurl yields a tarball, not a loadable module directory.
    mkdir -p $out/lib/context-mode/node_modules/zod
    tar -xzf ${finalAttrs.passthru.zod} --strip-components=1 -C $out/lib/context-mode/node_modules/zod
    # Payload self-references as "context-mode/plugin", resolvable only from
    # inside a node_modules directory.
    ln -s $out/lib/context-mode $out/lib/context-mode/node_modules/context-mode

    # The eight real agent skills (see dontInstallAgentSkills above).
    for skill in skills/*/; do installSkill "$skill"; done

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

  passthru = {
    zod = fetchurl {
      url = "https://registry.npmjs.org/zod/-/zod-3.25.76.tgz";
      hash = "sha256-nh8aBfDdDB2rZO6Rzrm/Vc1E01Noxw7dqAov3HCog3c=";
    };
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      ./update-zod.sh
    ];
  };

  meta = {
    description = "Context window optimization plugin and MCP server for AI coding agents";
    homepage = "https://github.com/mksglu/context-mode";
    license = lib.licenses.elastic20;
    maintainers = with lib.maintainers; [ eana ];
    mainProgram = "context-mode";
    platforms = lib.platforms.all;
  };
})
