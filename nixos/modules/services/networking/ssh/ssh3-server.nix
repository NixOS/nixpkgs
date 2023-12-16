{ pkgs, config, lib, utils, ... }:
let
  inherit (lib)
    concatLists
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types;
  inherit (utils) escapeSystemdExecArgs;
  cfg = config.services.ssh3-server;
  acmeDirectory = config.security.acme.certs.${cfg.domain}.directory;
in
  {
    options.services.ssh3-server = {
      enable = mkEnableOption "ssh3-server, a SSH3 (QUIC+TLS 1.3) server for secure remote logins";

      package = mkPackageOption pkgs "ssh3" { };
      listenAddresses = mkOption {
        type = with types; listOf (submodule {
          options = {
            addr = mkOption {
              type = str;
              description = ''
                Host, IPv4 or IPv6 address to listen to.
              '';
            };
            port = mkOption {
              type = port;
              description = ''
                Port to listen to.
              '';
            };
          };
        });
        # Keep 22 or 443... ?
        default = [ { addr = "[::]"; port = 443; } ];
        example = [ { addr = "192.168.3.1"; port = 22; } { addr = "0.0.0.0"; port = 64022; } ];
        description = ''
          List of addresses and ports to listen on (ListenAddress directive
          in config). If port is not specified for address sshd will listen
          on all ports specified by `ports` option.
          NOTE: this will override default listening on all local addresses and port 22.
          NOTE: setting this option won't automatically enable given ports
          in firewall configuration.
        '';
      };

      # Certificate stuff
      domain = mkOption {
        type = types.str;
        description = "Domain name for this server";
      };

      certificate = {
        publicKeyPath = mkOption {
          type = types.path;
          description = "Path to the public key of the certificate, often a full chain";
          default = "${acmeDirectory}/fullchain.pem";
          defaultText = lib.literalExpression "(ACME directory for this domain)/fullchain.pem";
        };
        privateKeyPath = mkOption {
          type = types.path;
          description = "Path to the private key of the certificate";
          default = "${acmeDirectory}/key.pem";
          defaultText = lib.literalExpression "(ACME directory for this domain)/key.pem";
        };
      };

      urlPath = mkOption {
        type = types.str;
        description = ''
          An ideally "secret" (read: non trivially scrapable or guessable by a Internet scanner)
          URL path for initiating the authentication to the server.

          If this has to be top secret, please invent a `urlPathFile` to avoid
          it falling in your Nix store and in your configuration.
        '';
      };
    };

    config = mkIf cfg.enable {
      systemd.services.ssh3-server =
      {
        description = "SSH3 Daemon";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" "acme-finished-${cfg.domain}.target" ];

        serviceConfig = {
          ExecStart = escapeSystemdExecArgs ([
            (lib.getExe' cfg.package "ssh3-server")
             "-cert" cfg.certificate.publicKeyPath
             "-key" cfg.certificate.privateKeyPath
             "-url-path" cfg.urlPath
           ] ++ (concatLists (map ({ addr, port }: [ "-bind" "${addr}:${toString port}" ]) cfg.listenAddresses)));
          KillMode = "process";
          Restart = "always";
          Type = "simple";
        };
      };
    };
  }
