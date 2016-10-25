{ config, lib, pkgs, ... }:

with lib;

let

  boolSwitch = value: if value then "yes" else "no";

  libDir = "/var/lib/bareos";

  fd_cfg = config.services.bareos-fd;
  fd_conf = pkgs.writeText "bareos-fd.conf"
    ''
      Director {
        Name = ${fd_cfg.director.name}
        Password = "${fd_cfg.director.password}"
        Address = ${fd_cfg.director.address}
        ${optionalString fd_cfg.tls.enable ''
          TLS Enable = ${boolSwitch fd_cfg.tls.enable}
          TLS Require = ${boolSwitch fd_cfg.tls.require}
          TLS Verify Peer = ${boolSwitch fd_cfg.tls.verify}
          TLS ALLOWED CN = ${fd_cfg.tls.allowed}
          TLS CA Certificate File = ${fd_cfg.tls.ca}
          TLS Certificate = ${fd_cfg.tls.cert}
          TLS Key = ${fd_cfg.tls.key}
          TLS DH File = ${fd_cfg.tls.dh} ''}
        ${fd_cfg.extraDirectorConfig}
      }

      FileDaemon {
        Name = ${fd_cfg.name}
        WorkingDirectory = "${libDir}"
        ${concatMapStrings ({ protocol, addr, ... }: ''
          FDAddresses = { ${protocol} = { addr = ${addr} }} '') fd_cfg.listen}
        Compatible = ${boolSwitch fd_cfg.compatible}
        ${optionalString fd_cfg.tls.enable ''
          TLS Enable = ${boolSwitch fd_cfg.tls.enable}
          TLS Require = ${boolSwitch fd_cfg.tls.require}
          TLS CA Certificate File = ${fd_cfg.tls.ca}
          TLS Certificate = ${fd_cfg.tls.cert}
          TLS Key = ${fd_cfg.tls.key} ''}
        ${optionalString fd_cfg.pki.enable ''
          PKI Signatures = ${boolSwitch fd_cfg.pki.signature}
          PKI Encryption = ${boolSwitch fd_cfg.pki.encryption}
          PKI Keypair = ${fd_cfg.pki.keypair}
          PKI Master Key = ${fd_cfg.pki.key} ''}
        ${fd_cfg.extraClientConfig}
      }

      Messages {
        Name = Standard
        director = "${fd_cfg.director.name}" = all, !skipped, !restored
        ${fd_cfg.extraMessagesConfig}
      }
    '';

in {
  options = {
    services.bareos-fd = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the Bareos File Daemon.
        '';
      };

      name = mkOption {
        default = "${config.networking.hostName}-fd";
        description = ''
          The client name that must be used by the Director when connecting.
          Generally, it is a good idea to use a name related to the machine
          so that error messages can be easily identified if you have multiple
          Clients. This directive is required.
        '';
      };

      listen = mkOption {
        type = with types; listOf (submodule {
          options = {
            protocol = mkOption {
              type = types.enum ["ipv4" "ipv6"];
              default = "ipv4";
              description = ''
                IP type, IPv4 or IPv6.
              '';
            };
            addr = mkOption {
              type = types.nullOr types.str;
              default = "127.0.0.1";
              description = ''
                IP address client should listen on.
              '';
            };
          };
        });
      };

      compatible = mkOption {
         default = true;
         description = ''
           Run Bareos in Compatibility mode.
         '';
      };

      pki = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enable PKI.
          '';
        };

        signature = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enable PKI Signatures.
          '';
        };

        encryption = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enable PKI Encryption.
          '';
        };

        keypair = mkOption {
          default = "";
          description = ''
            Path to PKI keypair file.
          '';
        };

        key = mkOption {
          default = "";
          description = ''
            Path to PKI data key file.
          '';
        };
      };

      tls = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enable TLS. This enables it for both the FD and Director.
          '';
        };

        require = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Is TLS required?
          '';
        };

        allowed = mkOption {
          default = "";
          description = ''
            Set the allowed CN.
          '';
        };

        verify = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Verify peer?
          '';
        };

        dh = mkOption {
          default = "";
          description = ''
            Path to DH file.
          '';
        };

        ca = mkOption {
          default = "";
          description = ''
            Path to CA certificate file.
          '';
        };

        cert = mkOption {
          default = "";
          description = ''
            Path to Certificate file.
          '';
        };

        key = mkOption {
          default = "";
          description = ''
            Path to private key file.
          '';
        };
      };

      director = {
        name = mkOption {
          default = "";
          description = ''
            Name of the director server.
          '';
        };

        password = mkOption {
          default = "";
          description = ''
            Director password.
          '';
        };

        address = mkOption {
          default = "";
          description = ''
            Address of Director Server.
          '';
        };
      };

      extraClientConfig = mkOption {
        default = "";
        description = ''
          Extra configuration to be passed in Client directive.
        '';
        example = ''
          Maximum Concurrent Jobs = 20;
          Heartbeat Interval = 30;
        '';
      };

      extraDirectorConfig = mkOption {
        type = types.str;
        default = "";
        description = ''
          Extra configuration to be passed in Director directive.
        '';
        example = ''
          Maximum Concurrent Jobs = 20;
          Heartbeat Interval = 30;
        '';
      };

      extraMessagesConfig = mkOption {
        default = "";
        description = ''
          Extra configuration to be passed in Messages directive.
        '';
        example = ''
          console = all
        '';
      };
    };
  };

  config = mkIf (fd_cfg.enable) {
    systemd.services.bareos-fd = mkIf fd_cfg.enable {
      after = [ "network.target" ];
      description = "Bareos File Daemon";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.bareos ];
      serviceConfig.ExecStart = "${pkgs.bareos}/bin/bareos-fd -f -u root -g bareos -c ${fd_conf}";
      serviceConfig.ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      preStart = ''
        mkdir -p "/var/run/bareos/"
        mkdir -p "{$libDir}"
      '';
    };

    environment.systemPackages = [ pkgs.bareos ];

    users.extraUsers.bareos = {
      group = "bareos";
      uid = config.ids.uids.bareos;
      home = "${libDir}";
      createHome = true;
      description = "Bareos Daemons user";
      shell = "${pkgs.bash}/bin/bash";
    };

    users.extraGroups.bareos.gid = config.ids.gids.bareos;
  };
}
