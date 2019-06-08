{ config, pkgs, lib, ... }:

with lib;

let
  dataDir = "/var/lib/matrix-appservice-irc";
  systemUser = "matrix-appservice-irc";
  systemGroup = "matrix-appservice-irc";

  cfg = config.services.matrix-appservice-irc;
  # TODO: switch to configGen.json once RFC42 is implemented
  settingsFile = pkgs.writeText "matrix-appservice-irc-settings.json" (builtins.toJSON cfg.settings);

in {
  options = {
    services.matrix-appservice-irc = {
      enable = mkEnableOption "a Node.js IRC bridge for Matrix";

      # TODO: switch to types.config.json as prescribed by RFC42 once it's implemented
      settings = mkOption rec {
        type = types.attrs;
        apply = recursiveUpdate default;
        default = {
          ircService = {
            databaseUri = "nedb://${dataDir}/data";
            passwordEncryptionKeyPath = "${dataDir}/passkey.pem";
          };
        };
        example = literalExample ''
          {
            homeserver = {
              url = "http://localhost:8008";
              domain = "localhost";
            };
            ircService.servers = {
              "irc.example.com" = {
                name = "ExampleNet";
                dynamicChannels.groupId = "+myircnetwork:localhost";
              };
            };
          }
        '';
        description = ''
          <filename>config.yaml</filename> configuration as a Nix attribute set.
          </para>

          <para>
          Configuration options should match those described in
          <link xlink:href="https://github.com/matrix-org/matrix-appservice-irc/blob/0.12.0/config.sample.yaml">
          config.sample.yaml</link>.
          </para>

          <para>
          Secret tokens should be specified using <option>environmentFile</option>
          instead of this world-readable attribute set.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 9999; # from https://github.com/matrix-org/matrix-appservice-irc/blob/0.12.0/README.md#4-running
        description = ''
          Port number on which the bridge should listen for internal communication with the Matrix homeserver.
        '';
      };

      registrationFile = mkOption {
        type = types.path;
        description = ''
          Application service registration file containing the appservice and homeserver secret tokens.
          </para>

          <para>
          This file should be kept outside of the world-readable nix store and be accessible to
          <literal>${systemUser}:${systemGroup}</literal>.
          </para>

          <para>
          See the
          <link xlink:href="https://github.com/matrix-org/matrix-appservice-irc#3-registration">setup procedure</link>
          for instructions on how to generate this file.
        '';
      };

      serviceDependencies = mkOption {
        type = with types; listOf str;
        default = [ ];
        example = literalExample ''
          [ "matrix-synapse.service" ]
        '';
        description = ''
          List of Systemd services to require and wait for when starting the application service.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
#    services.matrix-appservice-irc.settings = {
#      ircService = {
#        databaseUri = mkDefault "nedb://${dataDir}/data";
#        passwordEncryptionKeyPath = mkDefault "${dataDir}/passkey.pem";
#      };
#    };

    systemd.services.matrix-appservice-irc = {
      description = "Node.js IRC bridge for Matrix.";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ] ++ cfg.serviceDependencies;
      after = [ "network-online.target" ] ++ cfg.serviceDependencies;

      preStart = ''
        if [ ! -f '${cfg.settings.ircService.passwordEncryptionKeyPath}' ]; then
          echo "Generating password encryption key..."
          ${pkgs.openssl}/bin/openssl genpkey \
            -out '${cfg.settings.ircService.passwordEncryptionKeyPath}' \
            -outform PEM \
            -algorithm RSA \
            -pkeyopt rsa_keygen_bits:4096
          echo "Password encryption key generated."
        fi
      '';

      serviceConfig = {
        Type = "simple";
        Restart = "always";

        User = systemUser;
        Group = systemGroup;

        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;

        AmbientCapabilities = mkIf
          (cfg.port < 1024 || (cfg.settings.ident.enabled or false && cfg.settings.ident.port or 1113 < 1024))
          "CAP_NET_BIND_SERVICE";

        PrivateTmp = true;
        StateDirectory = baseNameOf dataDir;

        ExecStart = ''
          ${pkgs.matrix-appservice-irc}/bin/matrix-appservice-irc \
            --file='${toString cfg.registrationFile}' \
            --config='${settingsFile}' \
            --port='${toString cfg.port}'
        '';
      };
    };

    # Not using DynamicUser here so that ownership for the private `registrationFile` can be set
    users = {
      groups.${systemGroup} = { };
      users.${systemUser} = {
        description = "Node.js IRC bridge for Matrix";
        group = systemGroup;
        isSystemUser = true;
      };
    };

  };

  meta.maintainers = with maintainers; [ pacien ];
}
