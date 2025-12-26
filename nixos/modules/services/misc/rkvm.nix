{
  options,
  config,
  pkgs,
  lib,
  ...
}:
let
  opt = options.services.rkvm;
  cfg = config.services.rkvm;
  toml = pkgs.formats.toml { };
in
{
  meta.maintainers = [ ];

  options.services.rkvm = {
    enable = lib.mkOption {
      default = cfg.server.enable || cfg.client.enable;
      defaultText = lib.literalExpression "config.${opt.server.enable} || config.${opt.client.enable}";
      type = lib.types.bool;
      description = ''
        Whether to enable rkvm, a Virtual KVM switch for Linux machines.
      '';
    };

    package = lib.mkPackageOption pkgs "rkvm" { };

    server = {
      enable = lib.mkEnableOption "the rkvm server daemon (input transmitter)";

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = toml.type;
          options = {
            listen = lib.mkOption {
              type = lib.types.str;
              default = "0.0.0.0:5258";
              description = ''
                An internet socket address to listen on, either IPv4 or IPv6.
              '';
            };

            switch-keys = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [
                "left-alt"
                "left-ctrl"
              ];
              description = ''
                A key list specifying a host switch combination.

                _A list of key names is available in <https://github.com/htrefil/rkvm/blob/master/switch-keys.md>._
              '';
            };

            certificate = lib.mkOption {
              type = lib.types.path;
              default = "/etc/rkvm/certificate.pem";
              description = ''
                TLS certificate path.

                ::: {.note}
                This should be generated with {command}`rkvm-certificate-gen`.
                :::
              '';
            };

            key = lib.mkOption {
              type = lib.types.path;
              default = "/etc/rkvm/key.pem";
              description = ''
                TLS key path.

                ::: {.note}
                This should be generated with {command}`rkvm-certificate-gen`.
                :::
              '';
            };

            password = lib.mkOption {
              type = lib.types.str;
              description = ''
                Shared secret token to authenticate the client.
                Make sure this matches your client's config.
              '';
            };
          };
        };

        default = { };
        description = "Structured server daemon configuration";
      };
    };

    client = {
      enable = lib.mkEnableOption "the rkvm client daemon (input receiver)";

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = toml.type;
          options = {
            server = lib.mkOption {
              type = lib.types.str;
              example = "192.168.0.123:5258";
              description = ''
                An RKVM server's internet socket address, either IPv4 or IPv6.
              '';
            };

            certificate = lib.mkOption {
              type = lib.types.path;
              default = "/etc/rkvm/certificate.pem";
              description = ''
                TLS ceritficate path.

                ::: {.note}
                This should be generated with {command}`rkvm-certificate-gen`.
                :::
              '';
            };

            password = lib.mkOption {
              type = lib.types.str;
              description = ''
                Shared secret token to authenticate the client.
                Make sure this matches your server's config.
              '';
            };
          };
        };

        default = { };
        description = "Structured client daemon configuration";
      };
    };

  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services =
      let
        mkBase = component: {
          description = "RKVM ${component}";
          wantedBy = [ "multi-user.target" ];
          after =
            {
              server = [ "network.target" ];
              client = [ "network-online.target" ];
            }
            .${component};
          wants =
            {
              server = [ ];
              client = [ "network-online.target" ];
            }
            .${component};
          serviceConfig = {
            ExecStart = "${cfg.package}/bin/rkvm-${component} ${
              toml.generate "rkvm-${component}.toml" cfg.${component}.settings
            }";
            Restart = "always";
            RestartSec = 5;
            Type = "simple";
          };
        };
      in
      {
        rkvm-server = lib.mkIf cfg.server.enable (mkBase "server");
        rkvm-client = lib.mkIf cfg.client.enable (mkBase "client");
      };
  };

}
