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

      passwordFile = mkOption {
        description = ''
          Path to a file whose contents will be substituted for {option}`.settings.password` at runtime, to avoid placing the password in the nix store.

          The password (i.e., contents of this file) must natch between the server and all connecting clients.
        '';
        type = types.nullOr types.path; default = null;
      };

      useOwnSlice = lib.mkEnableOption ''
        running the rkvm ${component} service with higher priority.
        You can try this on the server and/or client when the forwarding, esp. the cursor, stutters even on a stable network connection.

        Specifically, this moves the server and/or client from `system.slice` into a new `rkvm.slice`, that is on the same hierarchical level as `system.slice` and `user.slice`.
        In case of resource contention, the `rkvm-${component}.service` will thus (by default) have the same priority as all other services (or user processes) combined.
      '';

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

          _A list of available key names is available at <https://github.com/htrefil/rkvm/blob/master/switch-keys.md>._
        '';
      };

    };

    client = mkCommonOptions "client" {
      server = mkOption {
        type = types.str;
        example = "192.168.0.123:5258";
        description = ''
          Hostname or IPv4/6 address and port number of the `rkvm` server to connect to.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services =
      let
        mkBase = component:
        let
          ccfg = cfg.${component};
        in
        {
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
            Restart = "always";
            RestartSec = 5;
            Type = "simple";
            Slice = lib.mkIf cfg.${component}.useOwnSlice "rkvm.slice";
          };
          script = ''
            ${cfg.package}/bin/rkvm-${component} ${if ccfg.passwordFile == null then (
              toml.generate "rkvm-${component}.toml" ccfg.settings
            ) else ''<(
                settings=$( cat ${
                  toml.generate "rkvm-${component}.toml" (ccfg.settings // { password = "REPLACE_PASSWORD"; })
                } ) || exit
                password=$( cat ${lib.escapeShellArg ccfg.passwordFile} ) || exit
                printf '%s\n' "''${settings/REPLACE_PASSWORD/$password}"
            )''}
          '';
        };
      in
      {
        rkvm-server = mkIf cfg.server.enable (mkBase "server");
        rkvm-client = mkIf cfg.client.enable (mkBase "client");
      };

      systemd.slices.rkvm = lib.mkIf (cfg.client.useOwnSlice || cfg.server.useOwnSlice) { };

  };

}
