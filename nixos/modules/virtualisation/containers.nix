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


  imports = [
    (
      lib.mkRemovedOptionModule
      [ "virtualisation" "containers" "users" ]
      "All users with `isNormalUser = true` set now get appropriate subuid/subgid mappings."
    )
  ];

  options.virtualisation.containers = {

    enable =
      mkOption {
        type = types.bool;
        default = false;
        description = ''
          This option enables the common /etc/containers configuration module.
        '';
      };

    containersConf = mkOption {
      default = {};
      description = "containers.conf configuration";
      type = types.submodule {
        options = {

          extraConfig = mkOption {
            type = types.lines;
            default = "";
            description = ''
              Extra configuration that should be put in the containers.conf
              configuration file
            '';

          };
        };
      };
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

  };

  config = lib.mkIf cfg.enable {

    environment.etc."containers/containers.conf".text = ''
      [network]
      cni_plugin_dirs = ["${pkgs.cni-plugins}/bin/"]

    '' + cfg.containersConf.extraConfig;

    environment.etc."containers/registries.conf".source = toTOML "registries.conf" {
      registries = lib.mapAttrs (n: v: { registries = v; }) cfg.registries;
    };

    environment.etc."containers/policy.json".source =
      if cfg.policy != {} then pkgs.writeText "policy.json" (builtins.toJSON cfg.policy)
      else copyFile "${pkgs.skopeo.src}/default-policy.json";
  };

}
