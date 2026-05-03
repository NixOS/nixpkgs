{
  lib,
  pkgs,
  config,
  ...
}:
let
  format = pkgs.formats.hcl1 { };
  cfg = config.services.spire.agent;
  http_challenge = cfg.settings.plugins.NodeAttestor.http_challenge;
in
{
  options.services.spire.agent = {
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Whether to open the firewall for `services.spire.agent.settings.plugins.NodeAttestor.http_challenge.plugin_data.port`.
      '';
      default = false;
    };

    settings.plugins.NodeAttestor.http_challenge = lib.mkOption {
      default = null;
      description = ''
        The `http_challenge` plugin handshakes via http to ensure the agent is
        running on a valid dns name.

        Must be used in conjunction with the server-side `http_challenge` plugin.
        See [the plugin documentation](https://github.com/spiffe/spire/blob/main/doc/plugin_agent_nodeattestor_http_challenge.md).
      '';
      type = lib.types.nullOr (
        lib.types.submodule {
          freeformType = format.type;
          options.plugin_data = lib.mkOption {
            default = { };
            description = "Plugin data for the http_challenge NodeAttestor.";
            type = lib.types.submodule {
              freeformType = format.type;
              options = {
                hostname = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = ''
                    Hostname to use for handshaking. If unset, it will be automatically detected.
                  '';
                };
                agentname = lib.mkOption {
                  type = lib.types.str;
                  default = "default";
                  description = ''
                    Name of this agent on the host. Useful if you have multiple agents bound to
                    different spire servers on the same host and sharing the same port.
                  '';
                };
                port = lib.mkOption {
                  type = lib.types.nullOr lib.types.port;
                  default = null;
                  description = ''
                    The port to listen on. If unspecified, a random value will be used.
                  '';
                };
                advertised_port = lib.mkOption {
                  type = lib.types.nullOr lib.types.port;
                  default = null;
                  description = ''
                    The port to tell the server to call back on. Defaults to `port`.
                  '';
                };
              };
            };
          };
        }
      );
    };
  };

  config = lib.mkIf (cfg.enable && http_challenge != null) {
    networking.firewall.allowedTCPPorts =
      lib.mkIf (cfg.openFirewall && http_challenge.plugin_data.port != null)
        [ http_challenge.plugin_data.port ];
  };
}
