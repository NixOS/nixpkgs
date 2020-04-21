{ config, lib, pkgs, ... }:
let
  cfg = config.virtualisation.containers;

  inherit (lib) mkOption types;

  # Once https://github.com/NixOS/nixpkgs/pull/75584 is merged we can use the TOML generator
  toTOML = name: value: pkgs.runCommandNoCC name {
    nativeBuildInputs = [ pkgs.remarshal ];
    value = builtins.toJSON value;
    passAsFile = [ "value" ];
  } ''
    json2toml "$valuePath" "$out"
  '';

  # Copy configuration files to avoid having the entire sources in the system closure
  copyFile = filePath: pkgs.runCommandNoCC (builtins.unsafeDiscardStringContext (builtins.baseNameOf filePath)) {} ''
    cp ${filePath} $out
  '';
in
{
  meta = {
    maintainers = [] ++ lib.teams.podman.members;
  };

  options.virtualisation.containers = {

    enable =
      mkOption {
        type = types.bool;
        default = false;
        description = ''
          This option enables the common libpod container configuration module.
        '';
      };

    registries = {
      search = mkOption {
        type = types.listOf types.str;
        default = [ "docker.io" "quay.io" ];
        description = ''
          List of repositories to search.
        '';
      };

      insecure = mkOption {
        default = [];
        type = types.listOf types.str;
        description = ''
          List of insecure repositories.
        '';
      };

      block = mkOption {
        default = [];
        type = types.listOf types.str;
        description = ''
          List of blocked repositories.
        '';
      };
    };

    policy = mkOption {
      default = {};
      type = types.attrs;
      example = lib.literalExample ''
        {
          default = [ { type = "insecureAcceptAnything"; } ];
          transports = {
            docker-daemon = {
              "" = [ { type = "insecureAcceptAnything"; } ];
            };
          };
        }
      '';
      description = ''
        Signature verification policy file.
        If this option is empty the default policy file from
        <literal>skopeo</literal> will be used.
      '';
    };

    users = mkOption {
      default = [];
      type = types.listOf types.str;
      description = ''
        List of users to set up subuid/subgid mappings for.
        This is a requirement for running rootless containers.
      '';
    };

    libpod = mkOption {
      default = {};
      description = "Libpod configuration";
      type = types.submodule {
        options = {

          extraConfig = mkOption {
            type = types.lines;
            default = "";
            description = ''
              Extra configuration that should be put in the libpod.conf
              configuration file
            '';

          };
        };
      };
    };

  };

  config = lib.mkIf cfg.enable {

    environment.etc."containers/libpod.conf".text = ''
      cni_plugin_dir = ["${pkgs.cni-plugins}/bin/"]
      cni_config_dir = "/etc/cni/net.d/"

    '' + cfg.libpod.extraConfig;

    environment.etc."containers/registries.conf".source = toTOML "registries.conf" {
      registries = lib.mapAttrs (n: v: { registries = v; }) cfg.registries;
    };

    users.extraUsers = builtins.listToAttrs (
      (
        builtins.foldl' (
          acc: user: {
            values = acc.values ++ [
              {
                name = user;
                value = {
                  subUidRanges = [ { startUid = acc.offset; count = 65536; } ];
                  subGidRanges = [ { startGid = acc.offset; count = 65536; } ];
                };
              }
            ];
            offset = acc.offset + 65536;
          }
        )
        { values = []; offset = 100000; } (lib.unique cfg.users)
      ).values
    );

    environment.etc."containers/policy.json".source =
      if cfg.policy != {} then pkgs.writeText "policy.json" (builtins.toJSON cfg.policy)
      else copyFile "${pkgs.skopeo.src}/default-policy.json";
  };

}
