testModuleArgs@{
  config,
  lib,
  hostPkgs,
  nodes,
  options,
  ...
}:

let
  inherit (lib)
    literalExpression
    literalMD
    mapAttrs
    mkDefault
    mkIf
    mkMerge
    mkOption
    mkForce
    optional
    optionalAttrs
    types
    ;

  inherit (hostPkgs.stdenv) hostPlatform;

  guestSystem =
    if hostPlatform.isLinux then
      hostPlatform.system
    else
      let
        hostToGuest = {
          "x86_64-darwin" = "x86_64-linux";
          "aarch64-darwin" = "aarch64-linux";
        };

        supportedHosts = lib.concatStringsSep ", " (lib.attrNames hostToGuest);

        message = "NixOS Test: don't know which VM guest system to pair with VM host system: ${hostPlatform.system}. Perhaps you intended to run the tests on a Linux host, or one of the following systems that may run NixOS tests: ${supportedHosts}";
      in
      hostToGuest.${hostPlatform.system} or (throw message);

  baseOS = import ../eval-config.nix {
    inherit lib;
    system = null; # use modularly defined system
    inherit (config.node) specialArgs;
    modules = [ config.defaults ];
    baseModules = (import ../../modules/module-list.nix) ++ [
      ./nixos-test-base.nix
      {
        key = "nodes";
        _module.args.nodes = config.nodesCompat;
      }
      (
        { config, ... }:
        {
          virtualisation.qemu.package = testModuleArgs.config.qemu.package;
          virtualisation.host.pkgs = hostPkgs;
        }
      )
      (
        { options, ... }:
        {
          key = "nodes.nix-pkgs";
          config = optionalAttrs (!config.node.pkgsReadOnly) (
            mkIf (!options.nixpkgs.pkgs.isDefined) {
              # TODO: switch to nixpkgs.hostPlatform and make sure containers-imperative test still evaluates.
              nixpkgs.system = guestSystem;
            }
          );
        }
      )
      testModuleArgs.config.extraBaseModules
    ];
  };

  # TODO (lib): Dedup with run.nix, add to lib/options.nix
  mkOneUp = opt: f: lib.mkOverride (opt.highestPrio - 1) (f opt.value);

in

{

  options = {
    sshBackdoor = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to turn on the VSOCK-based access to all VMs. This provides an unauthenticated access intended for debugging.";
      };
      vsockOffset = mkOption {
        default = 2;
        type = types.ints.between 2 4294967296;
        description = ''
          This field is only relevant when multiple users run the (interactive)
          driver outside the sandbox and with the SSH backdoor activated.
          The typical symptom for this being a problem are error messages like this:
          `vhost-vsock: unable to set guest cid: Address already in use`

          This option allows to assign an offset to each vsock number to
          resolve this.

          This is a 32bit number. The lowest possible vsock number is `3`
          (i.e. with the lowest node number being `1`, this is 2+1).
        '';
      };
    };

    node.type = mkOption {
      type = types.raw;
      default = baseOS.type;
      internal = true;
    };

    nodes = mkOption {
      type = types.lazyAttrsOf config.node.type;
      visible = "shallow";
      description = ''
        An attribute set of NixOS configuration modules.

        The configurations are augmented by the [`defaults`](#test-opt-defaults) option.

        They are assigned network addresses according to the `nixos/lib/testing/network.nix` module.

        A few special options are available, that aren't in a plain NixOS configuration. See [Configuring the nodes](#sec-nixos-test-nodes)
      '';
    };

    defaults = mkOption {
      description = ''
        NixOS configuration that is applied to all [{option}`nodes`](#test-opt-nodes).
      '';
      type = types.deferredModule;
      default = { };
    };

    extraBaseModules = mkOption {
      description = ''
        NixOS configuration that, like [{option}`defaults`](#test-opt-defaults), is applied to all [{option}`nodes`](#test-opt-nodes) and can not be undone with [`specialisation.<name>.inheritParentConfig`](https://search.nixos.org/options?show=specialisation.%3Cname%3E.inheritParentConfig&from=0&size=50&sort=relevance&type=packages&query=specialisation).
      '';
      type = types.deferredModule;
      default = { };
    };

    node.pkgs = mkOption {
      description = ''
        The Nixpkgs to use for the nodes.

        Setting this will make the `nixpkgs.*` options read-only, to avoid mistakenly testing with a Nixpkgs configuration that diverges from regular use.
      '';
      type = types.nullOr types.pkgs;
      default = null;
      defaultText = literalMD ''
        `null`, so construct `pkgs` according to the `nixpkgs.*` options as usual.
      '';
    };

    node.pkgsReadOnly = mkOption {
      description = ''
        Whether to make the `nixpkgs.*` options read-only. This is only relevant when [`node.pkgs`](#test-opt-node.pkgs) is set.

        Set this to `false` when any of the [`nodes`](#test-opt-nodes) needs to configure any of the `nixpkgs.*` options. This will slow down evaluation of your test a bit.
      '';
      type = types.bool;
      default = config.node.pkgs != null;
      defaultText = literalExpression ''node.pkgs != null'';
    };

    node.specialArgs = mkOption {
      type = types.lazyAttrsOf types.raw;
      default = { };
      description = ''
        An attribute set of arbitrary values that will be made available as module arguments during the resolution of module `imports`.

        Note that it is not possible to override these from within the NixOS configurations. If you argument is not relevant to `imports`, consider setting {option}`defaults._module.args.<name>` instead.
      '';
    };

    nodesCompat = mkOption {
      internal = true;
      description = ''
        Basically `_module.args.nodes`, but with backcompat and warnings added.

        This will go away.
      '';
    };
  };

  config = {
    _module.args.nodes = config.nodesCompat;
    nodesCompat = mapAttrs (
      name: config:
      config
      // {
        config =
          lib.warnIf (lib.oldestSupportedReleaseIsAtLeast 2211)
            "Module argument `nodes.${name}.config` is deprecated. Use `nodes.${name}` instead."
            config;
      }
    ) config.nodes;

    passthru.nodes = config.nodesCompat;

    extraDriverArgs = mkIf config.sshBackdoor.enable [
      "--dump-vsocks=${toString config.sshBackdoor.vsockOffset}"
    ];

    defaults = mkMerge [
      (mkIf config.node.pkgsReadOnly {
        nixpkgs.pkgs = config.node.pkgs;
        imports = [ ../../modules/misc/nixpkgs/read-only.nix ];
      })
      (mkIf config.sshBackdoor.enable (
        let
          inherit (config.sshBackdoor) vsockOffset;
        in
        { config, ... }:
        {
          services.openssh = {
            enable = true;
            settings = {
              PermitRootLogin = "yes";
              PermitEmptyPasswords = "yes";
            };
          };

          security.pam.services.sshd = {
            allowNullPassword = true;
          };

          virtualisation.qemu.options = [
            "-device vhost-vsock-pci,guest-cid=${
              toString (config.virtualisation.test.nodeNumber + vsockOffset)
            }"
          ];
        }
      ))
    ];

    # Docs: nixos/doc/manual/development/writing-nixos-tests.section.md
    /**
      See https://nixos.org/manual/nixos/unstable#sec-override-nixos-test
    */
    passthru.extendNixOS =
      {
        module,
        specialArgs ? { },
      }:
      config.passthru.extend {
        modules = [
          {
            extraBaseModules = module;
            node.specialArgs = mkOneUp options.node.specialArgs (_: specialArgs);
          }
        ];
      };

  };
}
