{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.cloudflared;
in
{
  meta.maintainers = with maintainers; [ bbigras ];

  options.services.cloudflared = {
    enable = mkEnableOption "Cloudflared Argo Tunnel client daemon";

    package = mkOption {
      type = types.package;
      default = pkgs.cloudflared;
      defaultText = "pkgs.cloudflared";
      description = "The package to use for Cloudflared";
    };

    tunnels = mkOption {
      description = ''
        Cloudflare tunnels
      '';
      type = types.attrsOf (types.submodule ({ name, ... }: {
        options = {
          tunnel = mkOption {
            type = with types; nullOr str;
            default = null;
            description = ''
              Tunnel ID
            '';
            example = "00000000-0000-0000-0000-000000000000";
          };

          credentialsFile = mkOption {
            type = with types; nullOr str;
            default = null;
            description = ''
              credential file
            '';
          };

          default = mkOption {
            type = with types; nullOr str;
            default = null;
            description = ''
              Catch-all if no ingress matches
            '';
            example = "http_status:404";
          };

          ingress = mkOption {
            type = types.attrsOf types.str;
            default = { };
            example = {
              "*.domain.com" = "http://localhost:80";
              "*.anotherone.com" = "http://localhost:80";
            };
          };
        };
      }));

      default = { };
    };
  };

  config = {
    systemd.services =
      mapAttrs'
        (name: tunnel:
          let
            fullConfig = {
              tunnel = name;
              "credentials-file" = tunnel.credentialsFile;
              ingress = (map
                (key: {
                  hostname = key;
                  service = getAttr key tunnel.ingress;
                })
                (attrNames tunnel.ingress)) ++ [{ service = tunnel.default; }];
            };
            mkConfigFile = pkgs.writeText "cloudflared.yml" (builtins.toJSON fullConfig);
          in
          nameValuePair "cloudflared-tunnel-${name}" ({
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              ExecStart = "${cfg.package}/bin/cloudflared tunnel --config=${mkConfigFile} --no-autoupdate run";
              Restart = "always";
            };
          })
        )
        config.services.cloudflared.tunnels;
  };
}
