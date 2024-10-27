{ options, config, pkgs, lib, ... }:
let
  opt = options.services.rkvm;
  cfg = config.services.rkvm;
  toml = pkgs.formats.toml { };
  inherit (lib) mkOption mkEnableOption types mkIf;
in
{
  meta.maintainers = [ lib.maintainers.NiklasGollenstede ];

  options.services.rkvm = let

    enable = mkOption {
      default = cfg.server.enable || cfg.client.enable;
      defaultText = lib.literalExpression "config.${opt.server.enable} || config.${opt.client.enable}";
      type = types.bool;
      description = ''
        Whether to enable rkvm, a Virtual KVM switch for Linux machines.
      '';
    };

    package = lib.mkPackageOption pkgs "rkvm" { };

    mkCommonOptions = component: extraSettings: {
      enable = mkEnableOption "the rkvm ${component} daemon (input ${
        if component == "server" then "transmitter" else "receiver"
      })";

      settings = mkOption {
        description = "Structured ${component} daemon configuration";
        default = { };
        type = types.submodule {
          freeformType = toml.type;
          options = ({

            certificate = mkOption {
              type = types.path; default = "/etc/rkvm/certificate.pem";
              description = ''
                Path to the TLS public certificate file.

                ::: {.note}
                This can be generated with {command}`rkvm-certificate-gen`.
                :::
              '';
            };

            password = mkOption {
              type = types.nullOr types.str; default = null;
              description = ''
                Shared **secret** token to authenticate the client.

                ::: {.warning}
                You should NOT set this option directly, since this is a secret and all options set in nix itself will be world-readable.
                Use {option}`..passwordFile` instead.
                :::
              '';
            };

          } // extraSettings);
        };

      };
    };

  in {
    inherit enable package;

    server = mkCommonOptions "server" {

      listen = mkOption {
        type = types.str;
        default = "0.0.0.0:5258";
        description = ''
          Hostname or IPv4/6 address and port number to listen on.
        '';
      };

      key = mkOption {
        type = types.path; default = "/etc/rkvm/key.pem";
        description = ''
          Path to the TLS private key file (that matches the {option}`.certificate`).

          ::: {.warning}
          As a secret, this should not be stored in the nix store. Do not add the (unencrypted) file to your repository, and do not use an unquoted path to reference it.
          :::
        '';
      };

      switch-keys = mkOption {
        type = types.listOf types.str;
        default = [ "left-alt" "left-ctrl" ];
        description = ''
          A list of keys that, when pressed simultaneously, switch between the clients registered at the server (for this, the server itself is considered a client).

          _A list of available key names is available at <https://github.com/htrefil/rkvm/blob/${cfg.package.version}/switch-keys.md>._
        '';
      };

    };

    client = mkCommonOptions "client" {
      server = mkOption {
        type = types.str;
        example = "192.168.0.123:5258";
        description = ''
          An RKVM server's internet socket address, either IPv4 or IPv6.
        '';
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
