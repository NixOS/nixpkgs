{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.cloudflared;

  originRequest = {
    connectTimeout = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "30s";
      description = lib.mdDoc ''
        Timeout for establishing a new TCP connection to your origin server. This excludes the time taken to establish TLS, which is controlled by [https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/configuration/local-management/ingress/#tlstimeout](tlsTimeout).
      '';
    };

    tlsTimeout = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "10s";
      description = lib.mdDoc ''
        Timeout for completing a TLS handshake to your origin server, if you have chosen to connect Tunnel to an HTTPS server.
      '';
    };

    tcpKeepAlive = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "30s";
      description = lib.mdDoc ''
        The timeout after which a TCP keepalive packet is sent on a connection between Tunnel and the origin server.
      '';
    };

    noHappyEyeballs = mkOption {
      type = with types; nullOr bool;
      default = null;
      example = false;
      description = lib.mdDoc ''
        Disable the “happy eyeballs” algorithm for IPv4/IPv6 fallback if your local network has misconfigured one of the protocols.
      '';
    };

    keepAliveConnections = mkOption {
      type = with types; nullOr int;
      default = null;
      example = 100;
      description = lib.mdDoc ''
        Maximum number of idle keepalive connections between Tunnel and your origin. This does not restrict the total number of concurrent connections.
      '';
    };

    keepAliveTimeout = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "1m30s";
      description = lib.mdDoc ''
        Timeout after which an idle keepalive connection can be discarded.
      '';
    };

    httpHostHeader = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "";
      description = lib.mdDoc ''
        Sets the HTTP `Host` header on requests sent to the local service.
      '';
    };

    originServerName = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "";
      description = lib.mdDoc ''
        Hostname that `cloudflared` should expect from your origin server certificate.
      '';
    };

    caPool = mkOption {
      type = with types; nullOr (either str path);
      default = null;
      example = "";
      description = lib.mdDoc ''
        Path to the certificate authority (CA) for the certificate of your origin. This option should be used only if your certificate is not signed by Cloudflare.
      '';
    };

    noTLSVerify = mkOption {
      type = with types; nullOr bool;
      default = null;
      example = false;
      description = lib.mdDoc ''
        Disables TLS verification of the certificate presented by your origin. Will allow any certificate from the origin to be accepted.
      '';
    };

    disableChunkedEncoding = mkOption {
      type = with types; nullOr bool;
      default = null;
      example = false;
      description = lib.mdDoc ''
        Disables chunked transfer encoding. Useful if you are running a WSGI server.
      '';
    };

    proxyAddress = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "127.0.0.1";
      description = lib.mdDoc ''
        `cloudflared` starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures the listen address for that proxy.
      '';
    };

    proxyPort = mkOption {
      type = with types; nullOr int;
      default = null;
      example = 0;
      description = lib.mdDoc ''
        `cloudflared` starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures the listen port for that proxy. If set to zero, an unused port will randomly be chosen.
      '';
    };

    proxyType = mkOption {
      type = with types; nullOr (enum [ "" "socks" ]);
      default = null;
      example = "";
      description = lib.mdDoc ''
        `cloudflared` starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures what type of proxy will be started. Valid options are:

        - `""` for the regular proxy
        - `"socks"` for a SOCKS5 proxy. Refer to the [https://developers.cloudflare.com/cloudflare-one/tutorials/kubectl/](tutorial on connecting through Cloudflare Access using kubectl) for more information.
      '';
    };
  };
in
{
  options.services.cloudflared = {
    enable = mkEnableOption (lib.mdDoc "Cloudflare Tunnel client daemon (formerly Argo Tunnel)");

    user = mkOption {
      type = types.str;
      default = "cloudflared";
      description = lib.mdDoc "User account under which Cloudflared runs.";
    };

    group = mkOption {
      type = types.str;
      default = "cloudflared";
      description = lib.mdDoc "Group under which cloudflared runs.";
    };

    package = mkPackageOption pkgs "cloudflared" { };

    tunnels = mkOption {
      description = lib.mdDoc ''
        Cloudflare tunnels.
      '';
      type = types.attrsOf (types.submodule ({ name, ... }: {
        options = {
          inherit originRequest;

          credentialsFile = mkOption {
            type = types.str;
            description = lib.mdDoc ''
              Credential file.

              See [https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-useful-terms/#credentials-file](Credentials file).
            '';
          };

          warp-routing = {
            enabled = mkOption {
              type = with types; nullOr bool;
              default = null;
              description = lib.mdDoc ''
                Enable warp routing.

                See [https://developers.cloudflare.com/cloudflare-one/tutorials/warp-to-tunnel/](Connect from WARP to a private network on Cloudflare using Cloudflare Tunnel).
              '';
            };
          };

          default = mkOption {
            type = types.str;
            description = lib.mdDoc ''
              Catch-all service if no ingress matches.

              See `service`.
            '';
            example = "http_status:404";
          };

          ingress = mkOption {
            type = with types; attrsOf (either str (submodule ({ hostname, ... }: {
              options = {
                inherit originRequest;

                service = mkOption {
                  type = with types; nullOr str;
                  default = null;
                  description = lib.mdDoc ''
                    Service to pass the traffic.

                    See [https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/configuration/local-management/ingress/#supported-protocols](Supported protocols).
                  '';
                  example = "http://localhost:80, tcp://localhost:8000, unix:/home/production/echo.sock, hello_world or http_status:404";
                };

                path = mkOption {
                  type = with types; nullOr str;
                  default = null;
                  description = lib.mdDoc ''
                    Path filter.

                    If not specified, all paths will be matched.
                  '';
                  example = "/*.(jpg|png|css|js)";
                };

              };
            })));
            default = { };
            description = lib.mdDoc ''
              Ingress rules.

              See [https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/configuration/local-management/ingress/](Ingress rules).
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

  config = mkIf cfg.enable {
    systemd.targets =
      mapAttrs'
        (name: tunnel:
          nameValuePair "cloudflared-tunnel-${name}" {
            description = "Cloudflare tunnel '${name}' target";
            requires = [ "cloudflared-tunnel-${name}.service" ];
            after = [ "cloudflared-tunnel-${name}.service" ];
            unitConfig.StopWhenUnneeded = true;
          }
        )
        config.services.cloudflared.tunnels;

    systemd.services =
      mapAttrs'
        (name: tunnel:
          let
            filterConfig = lib.attrsets.filterAttrsRecursive (_: v: ! builtins.elem v [ null [ ] { } ]);

            filterIngressSet = filterAttrs (_: v: builtins.typeOf v == "set");
            filterIngressStr = filterAttrs (_: v: builtins.typeOf v == "string");

            ingressesSet = filterIngressSet tunnel.ingress;
            ingressesStr = filterIngressStr tunnel.ingress;

            fullConfig = {
              tunnel = name;
              "credentials-file" = tunnel.credentialsFile;
              ingress =
                (map
                  (key: {
                    hostname = key;
                  } // getAttr key (filterConfig (filterConfig ingressesSet)))
                  (attrNames ingressesSet))
                ++
                (map
                  (key: {
                    hostname = key;
                    service = getAttr key ingressesStr;
                  })
                  (attrNames ingressesStr))
                ++ [{ service = tunnel.default; }];
            };
            mkConfigFile = pkgs.writeText "cloudflared.yml" (builtins.toJSON fullConfig);
          in
          nameValuePair "cloudflared-tunnel-${name}" ({
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

    users.users = mkIf (cfg.user == "cloudflared") {
      cloudflared = {
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "cloudflared") {
      cloudflared = { };
    };
  };

  meta.maintainers = with maintainers; [ bbigras ];
}
