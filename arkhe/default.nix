# Pacotes Arkhe. O src padrão é o snapshot versionado em source/.
# Para outro workspace, passe src explicitamente, fixado por revisão/hash,
# contendo Cargo.lock e os crates descritos nos arquivos pkgs/.
# O filtro limita fontes locais aos diretórios necessários ao workspace Cargo.
{
  pkgs,
  src ? ./source,
  contentAddressed ? false,
  rustPlatform ? pkgs.rustPlatform,
  version ? "0.1.0",
}:
let
  inherit (pkgs) lib;

  mkArkhePackage = pkgs.callPackage ./lib/mk-arkhe-package.nix {
    inherit rustPlatform;
  };

  # Allowlist: apenas o que o workspace Cargo compila, mais os diretórios de
  # fixtures referenciados por `include_str!`/`include_bytes!`
  # (`ontology/` e `tests/` na raiz). Sem isso, um `src = ../.` copiaria
  # dezenas de GB (`ops/`, `examples/`, `.venv/`) para o store do Nix.
  allowedTopLevel = [
    ".cargo"
    "Cargo.lock"
    "Cargo.toml"
    "apps"
    "cognition"
    "evidence"
    "governance"
    "integration"
    "integrations"
    "kernel"
    "ontology"
    "orchestration"
    "rust-toolchain.toml"
    "storage"
    "tests"
    "verification"
    "work"
  ];

  # Nomes podados em qualquer profundidade.
  excludedNames = [
    ".direnv"
    ".git"
    ".next"
    ".venv"
    "__pycache__"
    "arc-agi-3"
    "node_modules"
    "solana-proof"
    "target"
    "venv"
  ];

  excludedSuffixes = [
    ".exe"
    ".img"
    ".iso"
    ".log"
    ".mp4"
    ".msi"
    ".pdf"
    ".zip"
  ];

  sourceIsPath = builtins.isPath src || builtins.isString src;

  rootStr = lib.removeSuffix "/" (toString src);

  source =
    if sourceIsPath && !(builtins.pathExists (src + "/Cargo.lock")) then
      throw ''
        nixpkgs-arkhe: `src` não aponta para a raiz do monorepo Arkhe
        (Cargo.lock ausente em ${toString src}).
        Passe `src` explicitamente em `default.nix`/`overlay.nix`, ou mantenha
        este diretório dentro do monorepo.
      ''
    else if sourceIsPath then
      lib.cleanSourceWith {
        src = lib.cleanSource src;
        filter =
          path: _type:
          let
            pathStr = toString path;
            rel = lib.removePrefix (rootStr + "/") pathStr;
            top = lib.head (lib.splitString "/" rel);
            base = baseNameOf pathStr;
          in
          pathStr == rootStr
          || (
            !(builtins.elem base excludedNames)
            && !(lib.any (suffix: lib.hasSuffix suffix base) excludedSuffixes)
            && builtins.elem top allowedTopLevel
          );
      }
    else
      src;

  callPackage = file: pkgs.callPackage file {
    src = source;
    inherit
      contentAddressed
      mkArkhePackage
      version
      ;
  };

  arkhe-verify = callPackage ./pkgs/arkhe-verify.nix;
  arkhe-runtime = callPackage ./pkgs/arkhe-runtime.nix;
  arkhe-ask = callPackage ./pkgs/arkhe-ask.nix;
  arkhe-sql-migrate = callPackage ./pkgs/arkhe-sql-migrate.nix;
  arkhe-twin = callPackage ./pkgs/arkhe-twin.nix;
  arkhe-ollama = callPackage ./pkgs/arkhe-ollama.nix;
  arkhe-crm-bridge = callPackage ./pkgs/arkhe-crm-bridge.nix;
  arkhe-python-gate = callPackage ./pkgs/arkhe-python-gate.nix;

  arkhe-verify-wasm = pkgs.callPackage ./pkgs/arkhe-verify-wasm.nix {
    src = source;
    inherit
      contentAddressed
      mkArkhePackage
      version
      ;
  };
in
{
  inherit
    arkhe-verify
    arkhe-runtime
    arkhe-ask
    arkhe-sql-migrate
    arkhe-twin
    arkhe-ollama
    arkhe-crm-bridge
    arkhe-python-gate
    arkhe-verify-wasm
    ;

  # Metapacote: todos os CLIs em um único perfil.
  arkhe = pkgs.callPackage ./pkgs/arkhe.nix {
    inherit version contentAddressed;
    packages = [
      arkhe-verify
      arkhe-runtime
      arkhe-ask
      arkhe-sql-migrate
      arkhe-twin
      arkhe-ollama
      arkhe-crm-bridge
      arkhe-python-gate
    ];
  };

  lib = {
    inherit mkArkhePackage version;
    inherit contentAddressed;
    source = source;
  };
}
