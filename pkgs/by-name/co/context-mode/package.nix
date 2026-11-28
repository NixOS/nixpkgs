{
  lib,
  stdenv,
  fetchurl,
  fetchzip,
  bun,
  installAgentSkills,
  makeWrapper,
  nix-update-script,
  _experimental-update-script-combinators,
}:
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
    installAgentSkills
    makeWrapper
  ];

  dontBuild = true;

  # the default glob finds too many skill files that are not supposed to be installed
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

    # re-export the bundled build of build/server.js
    echo 'export * from "../server.bundle.mjs";' \
      > $out/lib/context-mode/build/server.js

    # zod is the plugin's last remaining bare import
    mkdir -p $out/lib/context-mode/node_modules
    ln -s ${finalAttrs.passthru.zod} $out/lib/context-mode/node_modules/zod
    # Payload self-references as "context-mode/plugin"
    ln -s $out/lib/context-mode $out/lib/context-mode/node_modules/context-mode

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
    zod = fetchzip {
      url = "https://registry.npmjs.org/zod/-/zod-3.25.76.tgz";
      hash = "sha256-pWjjUgdfKjeqIvEkjvmqmf0U3BW8x+mDes8sLUanltA=";
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
