testModuleArgs@{
  config,
  lib,
  hostPkgs,
  options,
  ...
}:

let
  inherit (lib)
    literalExpression
    literalMD
    mapAttrs
    mkIf
    mkMerge
    mkRemovedOptionModule
    mkOption
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

  baseOS =
    extraBaseModules:
    import ../eval-config.nix {
      inherit lib;
      system = null; # use modularly defined system
      inherit (config.node) specialArgs;
      modules = [ config.defaults ];
      baseModules =
        (import ../../modules/module-list.nix)
        ++ [
          ./nixos-test-base.nix
          {
            key = "nodes";
            _module.args = {
              inherit (config) containers;
              nodes = config.nodesCompat;
            };
          }
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
        ]
        ++ extraBaseModules;
    };
  baseQemuOS = baseOS [
    ../../modules/virtualisation/qemu-vm.nix
    testModuleArgs.config.extraBaseNodeModules
    config.nodeDefaults
    {
      key = "base-qemu";
      virtualisation.qemu = {
        inherit (testModuleArgs.config.qemu) package forceAccel;
      };
      virtualisation.host.pkgs = hostPkgs;
    }
  ];
  baseNspawnOS = baseOS [
    ../../modules/virtualisation/nspawn-container
    config.containerDefaults
    (
      { pkgs, ... }:
      {
        key = "base-nspawn";

        # PAM requires setuid and doesn't work in the build sandbox.
        # https://github.com/NixOS/nix/blob/959c244a1265f4048390f3ad21679219d7b27a99/src/libstore/unix/build/linux-derivation-builder.cc#L63
        services.openssh.settings.UsePAM = false;

        # Networking for tests is statically configured by default.
        # dhcpcd times out after blocking for a long time, which slows down tests.
        # See https://github.com/NixOS/nixpkgs/pull/478109#discussion_r2867570799
        networking.useDHCP = lib.mkDefault false;

        # Disable Info manual directory generation to prevent build failures.
        #
        # Context: 'install-info' (from texinfo) is triggered during system-path
        # generation to index manuals, but it requires 'gzip' in the $PATH to
        # decompress them.
        # When 'networking.useDHCP' is set to false, transitive dependencies
        # (like dhcpcd or other network tools) that normally pull 'gzip' into
        # the system environment are removed. This leaves 'install-info'
        # stranded without 'gzip', causing the 'system-path' derivation to fail.
        # Since nspawn containers are typically minimal, disabling 'info'
        # is a cleaner fix than explicitly adding 'gzip' to systemPackages.
        documentation.info.enable = lib.mkDefault false;

        # Gross, insecure hack to make login work. See above.
        security.pam.services.login = {
          text = ''
            auth sufficient ${pkgs.linux-pam}/lib/security/pam_permit.so
            account sufficient ${pkgs.linux-pam}/lib/security/pam_permit.so
            password sufficient ${pkgs.linux-pam}/lib/security/pam_permit.so
            session sufficient ${pkgs.linux-pam}/lib/security/pam_permit.so
          '';
        };
      }
    )
  ];

  # TODO (lib): Dedup with run.nix, add to lib/options.nix
  mkOneUp = opt: f: lib.mkOverride (opt.highestPrio - 1) (f opt.value);

in

{
  imports = [
    (mkRemovedOptionModule [ "sshBackdoor" "vsockOffset" ] ''
      The option `sshBackdoor.vsockOffset` has been removed from the testing framework.
      The functionality provided by it is not needed anymore.
    '')
  ];

  options = {
    sshBackdoor = {
      enable = mkOption {
        default = config.enableDebugHook;
        defaultText = lib.literalExpression "config.enableDebugHook";
        type = types.bool;
        description = "Whether to turn on the VSOCK-based access to all VMs. This provides an unauthenticated access intended for debugging.";
      };
    };

    node.type = mkOption {
      type = types.raw;
      default = baseQemuOS.type;
      internal = true;
    };

    nodes = mkOption {
      type = types.lazyAttrsOf config.node.type;
      default = { };
      visible = "shallow";
      description = ''
        An attribute set of NixOS configuration modules representing QEMU vms that can be started during a test.

        The configurations are augmented by the [`defaults`](#test-opt-defaults) option.

        They are assigned network addresses according to the `nixos/lib/testing/network.nix` module.

        A few special options are available, that aren't in a plain NixOS configuration. See [Configuring virtual machines](#ssec-nixos-test-qemu-vms)
      '';
    };

    container.type = mkOption {
      type = types.raw;
      default = baseNspawnOS.type;
      internal = true;
    };

    containers = mkOption {
      type = types.lazyAttrsOf config.container.type;
      default = { };
      visible = "shallow";
      description = ''
        An attribute set of NixOS configuration modules representing systemd-nspawn containers that can be started during a test.

        The configurations are augmented by the [`defaults`](#test-opt-defaults) option.

        They are assigned network addresses according to the `nixos/lib/testing/network.nix` module.

        A few special options are available, that aren't in a plain NixOS configuration. See [Configuring containers](#ssec-nixos-test-nspawn-containers)
      '';
    };

    allMachines = mkOption {
      readOnly = true;
      internal = true;
      description = ''
        Basically a merge of [{option}`nodes`](#test-opt-nodes) and [{option}`containers`](#test-opt-containers).

        This ensures that there are no name collisions between nodes and containers.
      '';
      default =
        let
          overlappingNames = lib.intersectLists (lib.attrNames config.nodes) (
            lib.attrNames config.containers
          );
        in
        lib.throwIfNot (overlappingNames == [ ])
          "The following names are used in both `nodes` and `containers`: ${lib.concatStringsSep ", " overlappingNames}"
          (config.nodes // config.containers);
    };

    defaults = mkOption {
      description = ''
        NixOS configuration that is applied to all [{option}`nodes`](#test-opt-nodes) and [{option}`containers`](#test-opt-containers).
      '';
      type = types.deferredModule;
      default = { };
    };

    nodeDefaults = mkOption {
      description = ''
        NixOS configuration that is applied to all [{option}`nodes`](#test-opt-nodes).
      '';
      type = types.deferredModule;
      default = { };
    };

    containerDefaults = mkOption {
      description = ''
        NixOS configuration that is applied to all [{option}`containers`](#test-opt-containers).
      '';
      type = types.deferredModule;
      default = { };
    };

    extraBaseModules = mkOption {
      description = ''
        NixOS configuration that, like [{option}`defaults`](#test-opt-defaults), is applied to all [{option}`nodes`](#test-opt-nodes) and [{option}`containers`](#test-opt-containers) and can not be undone with [`specialisation.<name>.inheritParentConfig`](https://search.nixos.org/options?show=specialisation.%3Cname%3E.inheritParentConfig&from=0&size=50&sort=relevance&type=packages&query=specialisation).
      '';
      type = types.deferredModule;
      default = { };
    };

    extraBaseNodeModules = mkOption {
      description = ''
        NixOS configuration that, like [{option}`defaults`](#test-opt-defaults), is applied to all [{option}`nodes`](#test-opt-nodes) and can not be undone with [`specialisation.<name>.inheritParentConfig`](https://search.nixos.org/options?show=specialisation.%3Cname%3E.inheritParentConfig&from=0&size=50&sort=relevance&type=packages&query=specialisation).
      '';
      type = types.deferredModule;
      default = { };
    };

    node.pkgs = mkOption {
      description = ''
        The Nixpkgs to use for the nodes and containers.

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

        Set this to `false` when any of the [`nodes`](#test-opt-nodes) or [{option}`containers`](#test-opt-containers) need to configure any of the `nixpkgs.*` options. This will slow down evaluation of your test a bit.
      '';
      type = types.bool;
      default = config.node.pkgs != null;
      defaultText = literalExpression "node.pkgs != null";
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
    _module.args.containers = config.containers;
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
    passthru.containers = config.containers;

    defaults = mkMerge [
      (mkIf config.node.pkgsReadOnly {
        nixpkgs.pkgs = config.node.pkgs;
        imports = [ ../../modules/misc/nixpkgs/read-only.nix ];
      })
      (mkIf config.sshBackdoor.enable {
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
      })
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
