{ lib, config, pkgs, ... }:

with lib;

let
  templateSubmodule = { ... }: {
    options = {
      enable = mkEnableOption (lib.mdDoc "this template");

      target = mkOption {
        description = lib.mdDoc "Path in the container";
        type = types.path;
      };
      template = mkOption {
        description = lib.mdDoc ".tpl file for rendering the target";
        type = types.path;
      };
      when = mkOption {
        description = lib.mdDoc "Events which trigger a rewrite (create, copy)";
        type = types.listOf (types.str);
      };
      properties = mkOption {
        description = lib.mdDoc "Additional properties";
        type = types.attrs;
        default = {};
      };
    };
  };

  toYAML = name: data: pkgs.writeText name (generators.toYAML {} data);

  cfg = config.virtualisation.lxc;
  templates = if cfg.templates != {} then let
    list = mapAttrsToList (name: value: { inherit name; } // value)
      (filterAttrs (name: value: value.enable) cfg.templates);
  in
    {
      files = map (tpl: {
        source = tpl.template;
        target = "/templates/${tpl.name}.tpl";
      }) list;
      properties = listToAttrs (map (tpl: nameValuePair tpl.target {
        when = tpl.when;
        template = "${tpl.name}.tpl";
        properties = tpl.properties;
      }) list);
    }
  else { files = []; properties = {}; };

in
{
  imports = [
    ../installer/cd-dvd/channel.nix
    ../profiles/clone-config.nix
    ../profiles/minimal.nix
  ];

  options = {
    virtualisation.lxc = {
      templates = mkOption {
        description = lib.mdDoc "Templates for LXD";
        type = types.attrsOf (types.submodule (templateSubmodule));
        default = {};
        example = literalExpression ''
          {
            # create /etc/hostname on container creation. also requires networking.hostName = "" to be set
            "hostname" = {
              enable = true;
              target = "/etc/hostname";
              template = builtins.toFile "hostname.tpl" "{{ container.name }}";
              when = [ "create" ];
            };
            # create /etc/nixos/hostname.nix with a configuration for keeping the hostname applied
            "hostname-nix" = {
              enable = true;
              target = "/etc/nixos/hostname.nix";
              template = builtins.toFile "hostname-nix.tpl" "{ ... }: { networking.hostName = \"{{ container.name }}\"; }";
              # copy keeps the file updated when the container is changed
              when = [ "create" "copy" ];
            };
            # copy allow the user to specify a custom configuration.nix
            "configuration-nix" = {
              enable = true;
              target = "/etc/nixos/configuration.nix";
              template = builtins.toFile "configuration-nix" "{{ config_get(\"user.user-data\", properties.default) }}";
              when = [ "create" ];
            };
          };
        '';
      };

      privilegedContainer = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether this LXC container will be running as a privileged container or not. If set to `true` then
          additional configuration will be applied to the `systemd` instance running within the container as
          recommended by [distrobuilder](https://linuxcontainers.org/distrobuilder/introduction/).
        '';
      };
    };
  };

  config = {
    boot.isContainer = true;
    boot.postBootCommands =
      ''
        # After booting, register the contents of the Nix store in the Nix
        # database.
        if [ -f /nix-path-registration ]; then
          ${config.nix.package.out}/bin/nix-store --load-db < /nix-path-registration &&
          rm /nix-path-registration
        fi

        # nixos-rebuild also requires a "system" profile
        ${config.nix.package.out}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system
      '';

    system.build.metadata = pkgs.callPackage ../../lib/make-system-tarball.nix {
      contents = [
        {
          source = toYAML "metadata.yaml" {
            architecture = builtins.elemAt (builtins.match "^([a-z0-9_]+).+" (toString pkgs.system)) 0;
            creation_date = 1;
            properties = {
              description = "${config.system.nixos.distroName} ${config.system.nixos.codeName} ${config.system.nixos.label} ${pkgs.system}";
              os = "${config.system.nixos.distroId}";
              release = "${config.system.nixos.codeName}";
            };
            templates = templates.properties;
          };
          target = "/metadata.yaml";
        }
      ] ++ templates.files;
    };

    # TODO: build rootfs as squashfs for faster unpack
    system.build.tarball = pkgs.callPackage ../../lib/make-system-tarball.nix {
      extraArgs = "--owner=0";

      storeContents = [
        {
          object = config.system.build.toplevel;
          symlink = "none";
        }
      ];

      contents = [
        {
          source = config.system.build.toplevel + "/init";
          target = "/sbin/init";
        }
      ];

      extraCommands = "mkdir -p proc sys dev";
    };

    # Add the overrides from lxd distrobuilder
    # https://github.com/lxc/distrobuilder/blob/05978d0d5a72718154f1525c7d043e090ba7c3e0/distrobuilder/main.go#L630
    systemd.packages = [
      (pkgs.writeTextFile {
        name = "systemd-lxc-service-overrides";
        destination = "/etc/systemd/system/service.d/zzz-lxc-service.conf";
        text = ''
          [Service]
          ProcSubset=all
          ProtectProc=default
          ProtectControlGroups=no
          ProtectKernelTunables=no
          NoNewPrivileges=no
          LoadCredential=
        '' + optionalString cfg.privilegedContainer ''
          # Additional settings for privileged containers
          ProtectHome=no
          ProtectSystem=no
          PrivateDevices=no
          PrivateTmp=no
          ProtectKernelLogs=no
          ProtectKernelModules=no
          ReadWritePaths=
        '';
      })
    ];

    # Allow the user to login as root without password.
    users.users.root.initialHashedPassword = mkOverride 150 "";

    system.activationScripts.installInitScript = mkForce ''
      ln -fs $systemConfig/init /sbin/init
    '';

    # Some more help text.
    services.getty.helpLine =
      ''

        Log in as "root" with an empty password.
      '';

    # Containers should be light-weight, so start sshd on demand.
    services.openssh.enable = mkDefault true;
    services.openssh.startWhenNeeded = mkDefault true;

    # As this is intended as a standalone image, undo some of the minimal profile stuff
    environment.noXlibs = false;
    documentation.enable = true;
    documentation.nixos.enable = true;
    services.logrotate.enable = true;
  };
}
