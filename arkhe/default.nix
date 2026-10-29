# Pacotes Arkhe. O src padrão é o snapshot versionado em source/.
#
# Com `src` path, cada pacote recebe uma fonte própria (lib/workspace.nix):
# só o fecho de crates dele entra no hash. Com `src` derivação (tarball
# fixado por hash), a fonte inteira é usada sem filtro.
#
# `rustPlatform*` vêm de lib/toolchain.nix no flake (Rust do
# rust-toolchain.toml); os padrões do nixpkgs existem só para quem importa
# este arquivo sem o flake.
{
  pkgs,
  src ? ./source,
  contentAddressed ? false,
  rustPlatform ? pkgs.rustPlatform,
  rustPlatformWasm ? rustPlatform,
  rustPlatformDev ? rustPlatform,
  version ? "0.1.0",
}:
let
  inherit (pkgs) lib;

  # Arquivos fora do diretório do crate lidos em tempo de compilação
  # (include_str!/include_bytes!/sqlx::migrate!). Um caminho esquecido aqui
  # quebra a compilação; nunca passa despercebido.
  crateExtras = {
    arkhe-core = [
      "tests/golden_vectors.json"
      "tests/classification_vectors.json"
      "tests/core_conformance_vectors.json"
    ];
    arkhe-verify-core = [
      "verification/tests/golden_vectors.json"
      "integration/arkhe-gov/fixtures"
      "integration/arkhe-rbb/fixtures"
    ];
    arkhe-wormgraph = [ "storage/sql/migrations" ];
    arkhe-runtime = [ "storage/sql/migrations" ];
    arkhe-sql-migrate = [ "storage/sql/migrations" ];
    arkhe-twin = [ "ontology" ];
  };

  workspace =
    if builtins.isPath src then
      if builtins.pathExists (src + "/Cargo.lock") then
        import ./lib/workspace.nix { inherit lib; } {
          root = src;
          inherit crateExtras;
        }
      else
        throw ''
          nixpkgs-arkhe: `src` não aponta para a raiz de um workspace Arkhe
          (Cargo.lock ausente em ${toString src}).
        ''
    else
      null;

  builderFor =
    platform:
    pkgs.callPackage ./lib/mk-arkhe-package.nix {
      rustPlatform = platform;
      inherit workspace;
    };

  mkArkhePackage = builderFor rustPlatform;
  mkArkhePackageWasm = builderFor rustPlatformWasm;
  mkArkhePackageDev = builderFor rustPlatformDev;

  callPackage =
    file: extra:
    pkgs.callPackage file (
      {
        inherit
          src
          contentAddressed
          mkArkhePackage
          version
          ;
      }
      // extra
    );

  arkhe-verify = callPackage ./pkgs/arkhe-verify.nix { };
  arkhe-runtime = callPackage ./pkgs/arkhe-runtime.nix { };
  arkhe-ask = callPackage ./pkgs/arkhe-ask.nix { };
  arkhe-sql-migrate = callPackage ./pkgs/arkhe-sql-migrate.nix { };
  arkhe-twin = callPackage ./pkgs/arkhe-twin.nix { };
  arkhe-ollama = callPackage ./pkgs/arkhe-ollama.nix { };
  arkhe-crm-bridge = callPackage ./pkgs/arkhe-crm-bridge.nix { };
  arkhe-python-gate = callPackage ./pkgs/arkhe-python-gate.nix { };
  arkhe-sdd-parser = callPackage ./pkgs/arkhe-sdd-parser.nix { };

  arkhe-verify-wasm = callPackage ./pkgs/arkhe-verify-wasm.nix {
    mkArkhePackage = mkArkhePackageWasm;
    lockFile = if workspace != null then src + "/Cargo.lock" else "${src}/Cargo.lock";
  };

  # Suítes `cargo test` dos crates de núcleo; a saída é o log.
  mkTests =
    crate: args:
    mkArkhePackage (
      {
        pname = "${crate}-tests";
        inherit crate src version;
        mode = "test";
      }
      // args
    );
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
    arkhe-sdd-parser
    arkhe-verify-wasm
    ;

  # Nome do crate Cargo, para quem procura por ele.
  arkhe-verify-cli = arkhe-verify;

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
      arkhe-sdd-parser
    ];
  };

  tests = {
    arkhe-core = mkTests "arkhe-core" {
      requiredTests = [
        {
          crate = "arkhe-core";
          test = "golden_vectors";
        }
      ];
    };
    arkhe-kernel = mkTests "arkhe-kernel" { };
    arkhe-governance = mkTests "arkhe-governance" { };

    # `-D warnings`, com duas exceções que já falham no monorepo (dívida
    # conhecida dele, não deste pacote), observadas com Rust 1.96.0:
    #   too_many_arguments  arkhe-governance
    #   useless_vec         arkhe-kernel/tests/support/gravit_signatures.rs:279
    # Remover cada exceção quando o código for corrigido.
    clippy = mkArkhePackageDev {
      pname = "arkhe-clippy";
      crate = "arkhe-core";
      inherit src version;
      mode = "clippy";
      testCrates = [
        "arkhe-kernel"
        "arkhe-governance"
        "arkhe-sdd-parser"
        "arkhe-verify-core"
        "arkhe-verify-cli"
      ];
      clippyFlags = [
        "-D"
        "warnings"
        "-A"
        "clippy::too_many_arguments"
        "-A"
        "clippy::useless_vec"
      ];
    };
  };

  lib = {
    inherit
      mkArkhePackage
      version
      contentAddressed
      workspace
      ;
    source = src;
  };
}
