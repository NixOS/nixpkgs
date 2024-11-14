{ config, lib, pkgs, ... }:
let
  cfg = config.services.cloudflared;

  originRequest = {
    connectTimeout = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "30s";
      description = ''
        Timeout for establishing a new TCP connection to your origin server. This excludes the time taken to establish TLS, which is controlled by [tlsTimeout](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/configuration/local-management/ingress/#tlstimeout).
      '';
    };

    tlsTimeout = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "10s";
      description = ''
        Timeout for completing a TLS handshake to your origin server, if you have chosen to connect Tunnel to an HTTPS server.
      '';
    };

    tcpKeepAlive = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "30s";
      description = ''
        The timeout after which a TCP keepalive packet is sent on a connection between Tunnel and the origin server.
      '';
    };

    noHappyEyeballs = lib.mkOption {
      type = with lib.types; nullOr bool;
      default = null;
      example = false;
      description = ''
        Disable the “happy eyeballs” algorithm for IPv4/IPv6 fallback if your local network has misconfigured one of the protocols.
      '';
    };

    keepAliveConnections = lib.mkOption {
      type = with lib.types; nullOr int;
      default = null;
      example = 100;
      description = ''
        Maximum number of idle keepalive connections between Tunnel and your origin. This does not restrict the total number of concurrent connections.
      '';
    };

    keepAliveTimeout = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "1m30s";
      description = ''
        Timeout after which an idle keepalive connection can be discarded.
      '';
    };

    httpHostHeader = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "";
      description = ''
        Sets the HTTP `Host` header on requests sent to the local service.
      '';
    };

    originServerName = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "";
      description = ''
        Hostname that `cloudflared` should expect from your origin server certificate.
      '';
    };

    caPool = lib.mkOption {
      type = with lib.types; nullOr (either str path);
      default = null;
      example = "";
      description = ''
        Path to the certificate authority (CA) for the certificate of your origin. This option should be used only if your certificate is not signed by Cloudflare.
      '';
    };

    noTLSVerify = lib.mkOption {
      type = with lib.types; nullOr bool;
      default = null;
      example = false;
      description = ''
        Disables TLS verification of the certificate presented by your origin. Will allow any certificate from the origin to be accepted.
      '';
    };

    disableChunkedEncoding = lib.mkOption {
      type = with lib.types; nullOr bool;
      default = null;
      example = false;
      description = ''
        Disables chunked transfer encoding. Useful if you are running a WSGI server.
      '';
    };

    proxyAddress = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "127.0.0.1";
      description = ''
        `cloudflared` starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures the listen address for that proxy.
      '';
    };

    proxyPort = lib.mkOption {
      type = with lib.types; nullOr int;
      default = null;
      example = 0;
      description = ''
        `cloudflared` starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures the listen port for that proxy. If set to zero, an unused port will randomly be chosen.
      '';
    };

    proxyType = lib.mkOption {
      type = with lib.types; nullOr (enum [ "" "socks" ]);
      default = null;
      example = "";
      description = ''
        `cloudflared` starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures what type of proxy will be started. Valid options are:

        - `""` for the regular proxy
        - `"socks"` for a SOCKS5 proxy. Refer to the [tutorial on connecting through Cloudflare Access using kubectl](https://developers.cloudflare.com/cloudflare-one/tutorials/kubectl/) for more information.
      '';
    };
  };
in
{
  options.services.cloudflared = {
    enable = lib.mkEnableOption "Cloudflare Tunnel client daemon (formerly Argo Tunnel)";

    user = lib.mkOption {
      type = lib.types.str;
      default = "cloudflared";
      description = "User account under which Cloudflared runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "cloudflared";
      description = "Group under which cloudflared runs.";
    };

    package = lib.mkPackageOption pkgs "cloudflared" { };

    tunnels = lib.mkOption {
      description = ''
        Cloudflare tunnels.
      '';
      type = lib.types.attrsOf (lib.types.submodule ({ name, ... }: {
        options = {
          inherit originRequest;

          credentialsFile = lib.mkOption {
            type = lib.types.str;
            description = ''
              Credential file.

              See [Credentials file](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-useful-terms/#credentials-file).
            '';
          };

          warp-routing = {
            enabled = lib.mkOption {
              type = with lib.types; nullOr bool;
              default = null;
              description = ''
                Enable warp routing.

                See [Connect from WARP to a private network on Cloudflare using Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/tutorials/warp-to-tunnel/).
              '';
            };
          };

          default = lib.mkOption {
            type = lib.types.str;
            description = ''
              Catch-all service if no ingress matches.

              See `service`.
            '';
            example = "http_status:404";
          };

          ingress = lib.mkOption {
            type = with lib.types; attrsOf (either str (submodule ({ hostname, ... }: {
              options = {
                inherit originRequest;

                service = lib.mkOption {
                  type = with lib.types; nullOr str;
                  default = null;
                  description = ''
                    Service to pass the traffic.

                    See [Supported protocols](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/configuration/local-management/ingress/#supported-protocols).
                  '';
                  example = "http://localhost:80, tcp://localhost:8000, unix:/home/production/echo.sock, hello_world or http_status:404";
                };

                path = lib.mkOption {
                  type = with lib.types; nullOr str;
                  default = null;
                  description = ''
                    Path filter.

                    If not specified, all paths will be matched.
                  '';
                  example = "/*.(jpg|png|css|js)";
                };

              };
            })));
            default = { };
            description = ''
              Ingress rules.

              See [Ingress rules](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/configuration/local-management/ingress/).
            '';
            example = {
              "*.domain.com" = "http://localhost:80";
              "*.anotherone.com" = "http://localhost:80";
            };
          };
        };
      }));

      default = { };
      example = {
        "00000000-0000-0000-0000-000000000000" = {
          credentialsFile = "/tmp/test";
          ingress = {
            "*.domain1.com" = {
              service = "http://localhost:80";
            };
          };
          default = "http_status:404";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.targets =
      lib.mapAttrs'
        (name: tunnel:
          lib.nameValuePair "cloudflared-tunnel-${name}" {
            description = "Cloudflare tunnel '${name}' target";
            requires = [ "cloudflared-tunnel-${name}.service" ];
            after = [ "cloudflared-tunnel-${name}.service" ];
            unitConfig.StopWhenUnneeded = true;
          }
        )
        config.services.cloudflared.tunnels;

    systemd.services =
      lib.mapAttrs'
        (name: tunnel:
          let
            filterConfig = lib.attrsets.filterAttrsRecursive (_: v: ! builtins.elem v [ null [ ] { } ]);

            filterIngressSet = lib.filterAttrs (_: v: builtins.typeOf v == "set");
            filterIngressStr = lib.filterAttrs (_: v: builtins.typeOf v == "string");

            ingressesSet = filterIngressSet tunnel.ingress;
            ingressesStr = filterIngressStr tunnel.ingress;

            fullConfig = filterConfig {
              tunnel = name;
              "credentials-file" = tunnel.credentialsFile;
              warp-routing = filterConfig tunnel.warp-routing;
              originRequest = filterConfig tunnel.originRequest;
              ingress =
                (map
                  (key: {
                    hostname = key;
                  } // lib.getAttr key (filterConfig (filterConfig ingressesSet)))
                  (lib.attrNames ingressesSet))
                ++
                (map
                  (key: {
                    hostname = key;
                    service = lib.getAttr key ingressesStr;
                  })
                  (lib.attrNames ingressesStr))
                ++ [{ service = tunnel.default; }];
            };

            mkConfigFile = pkgs.writeText "cloudflared.yml" (builtins.toJSON fullConfig);
          in
          lib.nameValuePair "cloudflared-tunnel-${name}" ({
            after = [ "network.target" "network-online.target" ];
            wants = [ "network.target" "network-online.target" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              User = cfg.user;
              Group = cfg.group;
              ExecStart = "${cfg.package}/bin/cloudflared tunnel --config=${mkConfigFile} --no-autoupdate run";
              Restart = "on-failure";
            };
          })
        )
        config.services.cloudflared.tunnels;

    users.users = lib.mkIf (cfg.user == "cloudflared") {
      cloudflared = {
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == "cloudflared") {
      cloudflared = { };
    };
  };

  meta.maintainers = with lib.maintainers; [ bbigras anpin ];
}
