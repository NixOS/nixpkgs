{ config, options, lib, pkgs, ... }:
let
  cfg = config.nixpkgs.flake;
in
{
  options.nixpkgs.flake = {
    source = lib.mkOption {
      # In newer Nix versions, particularly with lazy trees, outPath of
      # flakes becomes a Nix-language path object. We deliberately allow this
      # to gracefully come through the interface in discussion with @roberth.
      #
      # See: https://github.com/NixOS/nixpkgs/pull/278522#discussion_r1460292639
      type = lib.types.nullOr (lib.types.either lib.types.str lib.types.path);

      default = null;
      defaultText = "if (using nixpkgsFlake.lib.nixosSystem) then self.outPath else null";

      example = ''builtins.fetchTarball { name = "source"; sha256 = "${lib.fakeHash}"; url = "https://github.com/nixos/nixpkgs/archive/somecommit.tar.gz"; }'';

      description = ''
        The path to the nixpkgs sources used to build the system. This is automatically set up to be
        the store path of the nixpkgs flake used to build the system if using
        `nixpkgs.lib.nixosSystem`, and is otherwise null by default.

        This can also be optionally set if the NixOS system is not built with a flake but still uses
        pinned sources: set this to the store path for the nixpkgs sources used to build the system,
        as may be obtained by `builtins.fetchTarball`, for example.

        Note: the name of the store path must be "source" due to
        <https://github.com/NixOS/nix/issues/7075>.
      '';
    };

    setNixPath = lib.mkOption {
      type = lib.types.bool;

      default = cfg.source != null;
      defaultText = "config.nixpkgs.flake.source != null";

      description = ''
        Whether to set {env}`NIX_PATH` to include `nixpkgs=flake:nixpkgs` such that `<nixpkgs>`
        lookups receive the version of nixpkgs that the system was built with, in concert with
        {option}`nixpkgs.flake.setFlakeRegistry`.

        This is on by default for NixOS configurations built with flakes.

        This makes {command}`nix-build '<nixpkgs>' -A hello` work out of the box on flake systems.

        Note that this option makes the NixOS closure depend on the nixpkgs sources, which may add
        undesired closure size if the system will not have any nix commands run on it.
      '';
    };

    setFlakeRegistry = lib.mkOption {
      type = lib.types.bool;

      default = cfg.source != null;
      defaultText = "config.nixpkgs.flake.source != null";

      description = ''
        Whether to pin nixpkgs in the system-wide flake registry (`/etc/nix/registry.json`) to the
        store path of the sources of nixpkgs used to build the NixOS system.

        This is on by default for NixOS configurations built with flakes.

        This option makes {command}`nix run nixpkgs#hello` reuse dependencies from the system, avoid
        refetching nixpkgs, and have a consistent result every time.

        Note that this option makes the NixOS closure depend on the nixpkgs sources, which may add
        undesired closure size if the system will not have any nix commands run on it.
      '';
    };
  };

  config = lib.mkIf (cfg.source != null) (lib.mkMerge [
    {
      assertions = [
        {
          assertion = cfg.setNixPath -> cfg.setFlakeRegistry;
          message = ''
            Setting `nixpkgs.flake.setNixPath` requires that `nixpkgs.flake.setFlakeRegistry` also
            be set, since it is implemented in terms of indirection through the flake registry.
          '';
        }
      ];
    }
    (lib.mkIf cfg.setFlakeRegistry {
      nix.registry.nixpkgs.to = lib.mkDefault {
        type = "path";
        path = cfg.source;
      };
    })
    (lib.mkIf cfg.setNixPath {
      # N.B. This does not include nixos-config in NIX_PATH unlike modules/config/nix-channel.nix
      # because we would need some kind of evil shim taking the *calling* flake's self path,
      # perhaps, to ever make that work (in order to know where the Nix expr for the system came
      # from and how to call it).
      nix.nixPath = lib.mkDefault ([ "nixpkgs=flake:nixpkgs" ]
        ++ lib.optional config.nix.channel.enable "/nix/var/nix/profiles/per-user/root/channels");
    })
  ]);
}
