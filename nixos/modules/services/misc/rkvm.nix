{ options, config, pkgs, lib, ... }:

with lib;
let
  opt = options.services.rkvm;
  cfg = config.services.rkvm;
  toml = pkgs.formats.toml { };
in
{
  meta.maintainers = [ ];

  options.services.rkvm = {
    enable = mkOption {
      default = cfg.server.enable || cfg.client.enable;
      defaultText = literalExpression "config.${opt.server.enable} || config.${opt.client.enable}";
      type = types.bool;
      description = ''
        Whether to enable rkvm, a Virtual KVM switch for Linux machines.
      '';
    };

    package = mkPackageOption pkgs "rkvm" { };

    server = {
      enable = mkEnableOption "the rkvm server daemon (input transmitter)";

      settings = mkOption {
        type = types.submodule
          {
            freeformType = toml.type;
            options = {
              listen = mkOption {
                type = types.str;
                default = "0.0.0.0:5258";
                description = ''
                  An internet socket address to listen on, either IPv4 or IPv6.
                '';
              };

              switch-keys = mkOption {
                type = types.listOf types.str;
                default = [ "left-alt" "left-ctrl" ];
                description = ''
                  A key list specifying a host switch combination.

                  _A list of key names is available in <https://github.com/htrefil/rkvm/blob/master/switch-keys.md>._
                '';
              };

              certificate = mkOption {
                type = types.path;
                default = "/etc/rkvm/certificate.pem";
                description = ''
                  TLS certificate path.

                  ::: {.note}
                  This should be generated with {command}`rkvm-certificate-gen`.
                  :::
                '';
              };

              key = mkOption {
                type = types.path;
                default = "/etc/rkvm/key.pem";
                description = ''
                  TLS key path.

                  ::: {.note}
                  This should be generated with {command}`rkvm-certificate-gen`.
                  :::
                '';
              };

              password = mkOption {
                type = types.str;
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
      enable = mkEnableOption "the rkvm client daemon (input receiver)";

      settings = mkOption {
        type = types.submodule
          {
            freeformType = toml.type;
            options = {
              server = mkOption {
                type = types.str;
                example = "192.168.0.123:5258";
                description = ''
                  An RKVM server's internet socket address, either IPv4 or IPv6.
                '';
              };

              certificate = mkOption {
                type = types.path;
                default = "/etc/rkvm/certificate.pem";
                description = ''
                  TLS ceritficate path.

                  ::: {.note}
                  This should be generated with {command}`rkvm-certificate-gen`.
                  :::
                '';
              };

              password = mkOption {
                type = types.str;
                description = ''
                  Shared secret token to authenticate the client.
                  Make sure this matches your server's config.
                '';
              };
            };
          };

        default = {};
        description = "Structured client daemon configuration";
      };
    };

  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services =
      let
        mkBase = component: {
          description = "RKVM ${component}";
          wantedBy = [ "multi-user.target" ];
          after = {
            server = [ "network.target" ];
            client = [ "network-online.target" ];
          }.${component};
          wants = {
            server = [ ];
            client = [ "network-online.target" ];
          }.${component};
          serviceConfig = {
            ExecStart = "${cfg.package}/bin/rkvm-${component} ${toml.generate "rkvm-${component}.toml" cfg.${component}.settings}";
            Restart = "always";
            RestartSec = 5;
            Type = "simple";
          };
        };
      in
      {
        rkvm-server = mkIf cfg.server.enable (mkBase "server");
        rkvm-client = mkIf cfg.client.enable (mkBase "client");
      };
  };

}
