{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  bun,
  nodejs,
}:

buildNpmPackage (finalAttrs: {
  pname = "cspell-lsp";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "vlabo";
    repo = "cspell-lsp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZLZMVw0uvr4rQ9SKMVj1Sjoj+QeK2UL3RWsnzNRdPwI=";
  };

  npmDepsHash = "sha256-XYgtV3XMEriMjC06QfudL0fyoTY1PobnpUf4PQGOA2U=";

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [
    bun
  ];

  buildInputs = [ nodejs ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/cspell-lsp
    mkdir -p $out/bin

    # Re-install only production dependencies
    rm -rf node_modules
    bun install --production --frozen-lockfile

    mv ./package.json ./node_modules ./dist/cspell-lsp.js $out/lib/cspell-lsp
    # Clean up unneeded files
    pushd $out/lib/cspell-lsp
    shopt -s globstar
    rm -rf **/*.md  **/*.map **/*.d.ts **/src
    popd

    cat > $out/bin/${finalAttrs.meta.mainProgram} <<EOF
    #!/bin/sh
    exec ${nodejs}/bin/node $out/lib/cspell-lsp/cspell-lsp.js "\$@"
    EOF
    chmod +x $out/bin/${finalAttrs.meta.mainProgram}

    runHook postInstall
  '';

  meta = {
    description = "Spell checker language server using cspell";
    longDescription = ''
      A language server for spell checking in source code using the cspell library.
      Works with editors that support LSP such as Helix & Neovim.
    '';
    homepage = "https://github.com/vlabo/cspell-lsp";
    changelog = "https://github.com/vlabo/cspell-lsp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ duvallj ];
    mainProgram = "cspell-lsp";
    platforms = lib.platforms.all;
  };
})
