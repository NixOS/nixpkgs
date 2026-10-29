{
  description = "Pacotes Arkhe para Nix: builds reprodutíveis e endereçados por conteúdo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Fornece a toolchain do rust-toolchain.toml (tarballs oficiais com hash
    # fixo). `follows` evita um segundo nixpkgs no flake.lock.
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, rust-overlay, ... }:
    let
      inherit (nixpkgs) lib;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = lib.genAttrs systems;

      pkgsFor = system: nixpkgs.legacyPackages.${system};

      toolchainFor =
        pkgs:
        pkgs.callPackage ./lib/toolchain.nix {
          rust-bin = rust-overlay.lib.mkRustBin { } pkgs;
          toolchainFile = ./source/rust-toolchain.toml;
        };

      setFor =
        {
          system,
          contentAddressed ? false,
        }:
        let
          pkgs = pkgsFor system;
          toolchain = toolchainFor pkgs;
        in
        import ./default.nix {
          inherit pkgs contentAddressed;
          inherit (toolchain) rustPlatform rustPlatformWasm rustPlatformDev;
        };

      packagesFor = system: setFor { inherit system; };
    in
    {
      overlays.default = import ./overlay.nix { toolchain = toolchainFor; };
      overlays.contentAddressed = import ./overlay.nix {
        toolchain = toolchainFor;
        contentAddressed = true;
      };

      packages = forAllSystems (
        system:
        let
          p = packagesFor system;
        in
        (lib.filterAttrs (name: value: lib.isDerivation value) p) // { default = p.arkhe-verify; }
      );

      # `ca` fica fora de `packages` de propósito: instanciar uma derivação
      # endereçada por conteúdo exige `ca-derivations`, que ainda é
      # experimental. Assim `nix flake check` continua funcionando em uma
      # instalação padrão.
      legacyPackages = forAllSystems (
        system:
        let
          p = packagesFor system;
          ca = setFor {
            inherit system;
            contentAddressed = true;
          };
        in
        p // { ca = lib.filterAttrs (name: value: lib.isDerivation value) ca; }
      );

      checks = forAllSystems (
        system:
        import ./checks/default.nix {
          pkgs = pkgsFor system;
          packages = packagesFor system;
          toolchain = toolchainFor (pkgsFor system);
        }
      );

      apps = forAllSystems (system: {
        arkhe-verify = {
          type = "app";
          meta.description = "Verificador offline Arkhe";
          program = "${(packagesFor system).arkhe-verify}/bin/arkhe-verify";
        };
        arkhe-sdd-parser = {
          type = "app";
          meta.description = "spec.md/tasks.md SDD para CBOR canônico Arkhe";
          program = "${(packagesFor system).arkhe-sdd-parser}/bin/arkhe-sdd-parser";
        };
      });

      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = pkgs.mkShell {
            packages = [
              (toolchainFor pkgs).dev
              pkgs.diffoscopeMinimal
              pkgs.gnumake
              pkgs.jq
              pkgs.nix
            ];
          };
        }
      );

      # API para consumidores que trazem a própria fonte (por exemplo um
      # tarball de release fixado por hash).
      lib = {
        mkPackages =
          {
            pkgs,
            src,
            contentAddressed ? false,
          }:
          let
            toolchain = toolchainFor pkgs;
          in
          import ./default.nix {
            inherit pkgs src contentAddressed;
            inherit (toolchain) rustPlatform rustPlatformWasm rustPlatformDev;
          };

        mkOverlay = args: import ./overlay.nix ({ toolchain = toolchainFor; } // args);
      };

      nixosModules = {
        default = {
          imports = [
            ./modules/arkhe-node.nix
            ./modules/arkhe-audit.nix
          ];
        };
        arkhe-node = ./modules/arkhe-node.nix;
        arkhe-audit = ./modules/arkhe-audit.nix;
      };
    };
}
