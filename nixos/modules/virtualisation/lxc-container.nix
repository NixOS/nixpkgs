{ lib, config, pkgs, ... }:

with lib;

let
  templateSubmodule = { ... }: {
    options = {
      enable = mkEnableOption "this template";

      target = mkOption {
        description = "Path in the container";
        type = types.path;
      };
      template = mkOption {
        description = ".tpl file for rendering the target";
        type = types.path;
      };
      when = mkOption {
        description = "Events which trigger a rewrite (create, copy)";
        type = types.listOf (types.str);
      };
      properties = mkOption {
        description = "Additional properties";
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
    ../profiles/minimal.nix
    ../profiles/clone-config.nix
  ];

  options = {
    virtualisation.lxc = {
      templates = mkOption {
        description = "Templates for LXD";
        type = types.attrsOf (types.submodule (templateSubmodule));
        default = {};
        example = literalExample ''
          {
            # create /etc/hostname on container creation
            "hostname" = {
              enable = true;
              target = "/etc/hostname";
              template = builtins.writeFile "hostname.tpl" "{{ container.name }}";
              when = [ "create" ];
            };
            # create /etc/nixos/hostname.nix with a configuration for keeping the hostname applied
            "hostname-nix" = {
              enable = true;
              target = "/etc/nixos/hostname.nix";
              template = builtins.writeFile "hostname-nix.tpl" "{ ... }: { networking.hostName = "{{ container.name }}"; }";
              # copy keeps the file updated when the container is changed
              when = [ "create" "copy" ];
            };
            # copy allow the user to specify a custom configuration.nix
            "configuration-nix" = {
              enable = true;
              target = "/etc/nixos/configuration.nix";
              template = builtins.writeFile "configuration-nix" "{{ config_get(\"user.user-data\", properties.default) }}";
              when = [ "create" ];
            };
          };
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
              description = "NixOS ${config.system.nixos.codeName} ${config.system.nixos.label} ${pkgs.system}";
              os = "nixos";
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
    systemd.extraConfig = ''
      [Service]
      ProtectProc=default
      ProtectControlGroups=no
      ProtectKernelTunables=no
    '';

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
  };
}
