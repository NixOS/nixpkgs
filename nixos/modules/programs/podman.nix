{ config, pkgs, lib, ... }:

let
  cfg = config.programs.podman;

  surroundEachWith = str: list:
    map (e: str + (toString e) + str) list;

  registriesConf = let
    registryList = list:
      "registries = [" + (lib.concatStringsSep ", " (surroundEachWith "'" list)) + "]";
  in lib.concatStringsSep "\n" (lib.mapAttrsToList (type: registries: ''
    [registries.${type}]
    ${registryList registries}
  '') { inherit (cfg.registries) block insecure search; });

in {
  ###### interface

  options = {
    programs.podman = with lib; {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whenever to configure <command>podman</command> system-wide.";
      };

      installSystemWide = mkOption {
        type = types.bool;
        default = true;
        description = "Install packages system-wide.";
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
          default = [ ];
          type = types.listOf types.str;
          description = ''
            List of insecure repositories.
          '';
        };

        block = mkOption {
          default = [ ];
          type = types.listOf types.str;
          description = ''
            List of blocked repositories.
          '';
        };
      };

      policy = mkOption {
        default = {
          default = [ { type = "reject"; }];
        };
        type = types.attrs;
        example = literalExample ''
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
          Signature verification policy file
          </para>
          <para>
          The default will simply reject everything.
        '';
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    environment = {
      etc."containers/registries.conf".text = registriesConf;
      etc."containers/policy.json".text = builtins.toJSON cfg.policy;

      systemPackages = lib.mkIf cfg.installSystemWide
        (with pkgs; [ buildah fuse-overlayfs podman runc slirp4netns ]);
    };
  };
}
