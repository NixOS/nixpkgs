{
  config,
  options,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixpkgs;
  usingFlakes = config.system.build.usingFlakes;
in
{

  imports = [
    (lib.mkRenamedOptionModule [ "nixpkgs" "flake" "source" ] [ "nixpkgs" "source" ])
    (lib.mkRenamedOptionModule [ "nixpkgs" "flake" "setNixPath" ] [ "nixpkgs" "setNixPath" ])
    (lib.mkRenamedOptionModule
      [ "nixpkgs" "flake" "setFlakeRegistry" ]
      [ "nixpkgs" "setFlakeRegistry" ]
    )
  ];

  options.nixpkgs = {
    source = lib.mkOption {
      # In newer Nix versions, particularly with lazy trees, outPath of
      # flakes becomes a Nix-language path object. We deliberately allow this
      # to gracefully come through the interface in discussion with @roberth.
      #
      # See: https://github.com/NixOS/nixpkgs/pull/278522#discussion_r1460292639
      type = lib.types.nullOr (lib.types.either lib.types.str lib.types.path);

      default = null;
      defaultText = ''if (using nixpkgsFlake.lib.nixosSystem) then self.outPath else "<nixpkgs>"'';

      example = ''builtins.fetchTarball { name = "source"; sha256 = "${lib.fakeHash}"; url = "https://github.com/nixos/nixpkgs/archive/somecommit.tar.gz"; }'';

      description = ''
        If set, the path to the Nixpkgs sources that will be used by the
        `nixos-rebuild` tool to build the NixOS system, otherwise the default
        is to use `nixpkgs` from the {env}`NIX_PATH`.

        When using flakes, this is automatically set up to be the store path of
        the nixpkgs flake used to build the system if using
        `nixpkgs.lib.nixosSystem`, and is otherwise null by default.

        ::: {.note}
        The name of the store path must be "source" due to
        <https://github.com/NixOS/nix/issues/7075>.
        :::
      '';
    };

    setNixPath = lib.mkOption {
      type = lib.types.bool;

      default = cfg.source != null;
      defaultText = "config.nixpkgs.source != null";

      description = ''
        Whether to set {env}`NIX_PATH` so that `<nixpkgs>` lookups receive the
        version of Nixpkgs that the system was built with, meaning the value of
        {option}`nixpkgs.source`.

        This makes, for example, {command}`nix-build '<nixpkgs>' -A hello` work
        out of the box on systems built with flakes or with `nix-channel`
        disabled.

        When using flakes this option is on by default and will add
        `nixpkgs=flake:nixpkgs` to the {env}`NIX_PATH`, in concert with
        {option}`nixpkgs.setFlakeRegistry`.

        Note that this option makes the NixOS closure depend on the nixpkgs
        sources, which may add undesired closure size if the system will not
        have any nix commands run on it.
      '';
    };

    setFlakeRegistry = lib.mkOption {
      type = lib.types.bool;

      default = usingFlakes && cfg.source != null;
      defaultText = "config.nixpkgs.source != null";

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

  config = lib.mkIf (cfg.source != null) (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = (usingFlakes && cfg.setNixPath) -> cfg.setFlakeRegistry;
            message = ''
              Setting `nixpkgs.setNixPath` requires that `nixpkgs.setFlakeRegistry` also
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
        nix.nixPath = lib.mkDefault (
          lib.optional (!usingFlakes) "nixpkgs=${cfg.source}"
          ++ lib.optional usingFlakes "nixpkgs=flake:nixpkgs"
          ++ lib.optional (
            usingFlakes && config.nix.channel.enable
          ) "/nix/var/nix/profiles/per-user/root/channels"
        );
      })
    ]
  );
}
