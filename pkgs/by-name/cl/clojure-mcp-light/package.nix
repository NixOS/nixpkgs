{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  babashka,
  runtimeShell,
  parinfer-rust,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "clojure-mcp-light";
  version = "0.2.2";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "bhauman";
    repo = "clojure-mcp-light";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PzYQ6WBlApjGbiAy+FS7QC+Mriqr9Jq6d5cr0LZ2Unk=";
  };

  buildInputs = [
    babashka
    parinfer-rust
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase =
    let
      scripts = [
        {
          name = "clj-nrepl-eval";
          module = "clojure-mcp-light.nrepl-eval";
        }
        {
          name = "clj-paren-repair";
          module = "clojure-mcp-light.paren-repair";
        }
        {
          name = "clj-paren-repair-claude-hook";
          module = "clojure-mcp-light.hook";
        }
      ];
      mkScript = { name, module }: ''
        cat > $out/bin/${name} <<SCRIPT
        #!${runtimeShell}
        export PATH="${parinfer-rust}/bin:\$PATH"
        exec ${babashka}/bin/bb --config $src/bb.edn --deps-root $src -m ${module} -- "\$@"
        SCRIPT

        chmod +x $out/bin/${name}
      '';
    in
    ''
      runHook preInstall
      mkdir -p $out/bin
      ${lib.concatMapStrings mkScript scripts}
      runHook postInstall
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple Clojure tooling for AI coding assistants";
    homepage = "https://github.com/bhauman/clojure-mcp-light";
    changelog = "https://github.com/bhauman/clojure-mcp-light/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
    mainProgram = "clojure-mcp-light";
    platforms = lib.platforms.all;
  };
})
