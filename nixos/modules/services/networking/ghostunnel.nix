{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    attrValues
    concatStringsSep
    escapeShellArgs
    literalExpression
    mapAttrsToList
    mkEnableOption
    mkPackageOption
    mkIf
    mkOption
    types
    ;

  mainCfg = config.services.ghostunnel;

  module =
    { config, name, ... }:
    {
      options = {
        package = mkOption {
          default = mainCfg.package;
          defaultText = literalExpression "config.services.ghostunnel.package";
        };

        extraArguments = mkOption {
          description = "Extra arguments to pass to `ghostunnel server`";
          type = types.separatedString " ";
          default = "";
        };

        # Definitions to apply at the root of the NixOS configuration.
        atRoot = mkOption {
          internal = true;
        };
      };

      config.atRoot = {
        systemd.services."ghostunnel-server-${name}" = {
          after = [ "network.target" ];
          wants = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Restart = "always";
            AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
            DynamicUser = true;
            LoadCredential = mapAttrsToList (name: path: "${name}:${path}") config.credentials;
          };
          script = concatStringsSep " " (
            [ (escapeShellArgs config.portable.argv) ]
            ++ mapAttrsToList (name: _: "--${name}=$CREDENTIALS_DIRECTORY/${name}") config.credentials
            ++ [ config.extraArguments ]
          );
        };
      };
    };

in
{

  options = {
    services.ghostunnel.enable = mkEnableOption "ghostunnel";

    services.ghostunnel.package = mkPackageOption pkgs "ghostunnel" { };

    services.ghostunnel.servers = mkOption {
      description = ''
        Server mode ghostunnels (TLS listener -> plain TCP/UNIX target)
      '';
      type = types.attrsOf (
        types.submodule [
          ../../../../modules/generic/pkgs/by-name/gh/ghostunnel/commands/ghostunnel/server.nix
          module
        ]
      );
      default = { };
    };
  };

  config = mkIf mainCfg.enable {
    assertions = lib.concatMap (v: v.assertions) (attrValues mainCfg.servers);
    warnings = lib.concatMap (v: v.warnings) (attrValues mainCfg.servers);
    systemd = lib.mkMerge (map (v: v.atRoot.systemd) (attrValues mainCfg.servers));
  };

  meta = {
    maintainers = with lib.maintainers; [
      roberth
    ];
  };
}
