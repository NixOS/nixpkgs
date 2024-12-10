{
  lib,
  config,
  pkgs,
  ...
}:

let
  templateSubmodule =
    { ... }:
    {
      options = {
        enable = lib.mkEnableOption "this template";

        target = lib.mkOption {
          description = "Path in the container";
          type = lib.types.path;
        };
        template = lib.mkOption {
          description = ".tpl file for rendering the target";
          type = lib.types.path;
        };
        when = lib.mkOption {
          description = "Events which trigger a rewrite (create, copy)";
          type = lib.types.listOf (lib.types.str);
        };
        properties = lib.mkOption {
          description = "Additional properties";
          type = lib.types.attrs;
          default = { };
        };
      };
    };

  toYAML = name: data: pkgs.writeText name (lib.generators.toYAML { } data);

  cfg = config.virtualisation.lxc;
  templates =
    if cfg.templates != { } then
      let
        list = lib.mapAttrsToList (name: value: { inherit name; } // value) (
          lib.filterAttrs (name: value: value.enable) cfg.templates
        );
      in
      {
        files = map (tpl: {
          source = tpl.template;
          target = "/templates/${tpl.name}.tpl";
        }) list;
        properties = lib.listToAttrs (
          map (
            tpl:
            lib.nameValuePair tpl.target {
              when = tpl.when;
              template = "${tpl.name}.tpl";
              properties = tpl.properties;
            }
          ) list
        );
      }
    else
      {
        files = [ ];
        properties = { };
      };

in
{
  options = {
    virtualisation.lxc = {
      templates = lib.mkOption {
        description = "Templates for LXD";
        type = lib.types.attrsOf (lib.types.submodule templateSubmodule);
        default = { };
        example = lib.literalExpression ''
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
    system.build.metadata = pkgs.callPackage ../../lib/make-system-tarball.nix {
      contents = [
        {
          source = toYAML "metadata.yaml" {
            architecture = builtins.elemAt (builtins.match "^([a-z0-9_]+).+" (toString pkgs.stdenv.hostPlatform.system)) 0;
            creation_date = 1;
            properties = {
              description = "${config.system.nixos.distroName} ${config.system.nixos.codeName} ${config.system.nixos.label} ${pkgs.stdenv.hostPlatform.system}";
              os = "${config.system.nixos.distroId}";
              release = "${config.system.nixos.codeName}";
            };
            templates = templates.properties;
          };
          target = "/metadata.yaml";
        }
      ] ++ templates.files;
    };
  };
}
