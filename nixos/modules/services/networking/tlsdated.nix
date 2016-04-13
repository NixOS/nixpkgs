{ config, lib, pkgs, ... }:

with lib;

let
  inherit (pkgs) coreutils tlsdate;

  cfg = config.services.tlsdated;
in

{

  ###### interface

  options = {

    services.tlsdated = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable tlsdated daemon.
        '';
      };

      extraOptions = mkOption {
        type = types.string;
        default = "";
        description = ''
          Additional command line arguments to pass to tlsdated.
        '';
      };

      sources = mkOption {
        type = types.listOf (types.submodule {
          options = {
            host = mkOption {
              type = types.string;
              description = ''
                Remote hostname.
              '';
            };
            port = mkOption {
              type = types.int;
              description = ''
                Remote port.
              '';
            };
            proxy = mkOption {
              type = types.nullOr types.string;
              default = null;
              description = ''
                The proxy argument expects HTTP, SOCKS4A or SOCKS5 formatted as followed:

                 http://127.0.0.1:8118
                 socks4a://127.0.0.1:9050
                 socks5://127.0.0.1:9050

                The proxy support should not leak DNS requests and is suitable for use with Tor.
              '';
            };
          };
        });
        default = [
          {
            host = "encrypted.google.com";
            port = 443;
            proxy = null;
          }
        ];
        description = ''
          You can list one or more sources to fetch time from.
        '';
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    # Make tools such as tlsdate available in the system path
    environment.systemPackages = [ tlsdate ];

    systemd.services.tlsdated = {
      description = "tlsdated daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        # XXX because pkgs.tlsdate is compiled to run as nobody:nogroup, we
        # hard-code base-path to /tmp and use PrivateTmp.
        ExecStart = "${tlsdate}/bin/tlsdated -f ${pkgs.writeText "tlsdated.confg" ''
          base-path /tmp

          ${concatMapStrings (src: ''
          source
              host    ${src.host}
              port    ${toString src.port}
              proxy   ${if src.proxy == null then "none" else src.proxy}
          end
          '') cfg.sources}
        ''} ${cfg.extraOptions}";
        PrivateTmp = "yes";
      };
    };

  };

}
