{ config, lib, pkgs, ... }:
let
  cfg = config.services.dendrite;
  settingsFormat = pkgs.formats.yaml { };
  configurationYaml = settingsFormat.generate "dendrite.yaml" cfg.settings;
  workingDir = "/var/lib/dendrite";
in
{
  options.services.dendrite = {
    enable = lib.mkEnableOption "matrix.org dendrite";
    httpPort = lib.mkOption {
      type = lib.types.nullOr lib.types.port;
      default = 8008;
      description = ''
        The port to listen for HTTP requests on.
      '';
    };
    httpsPort = lib.mkOption {
      type = lib.types.nullOr lib.types.port;
      default = null;
      description = ''
        The port to listen for HTTPS requests on.
      '';
    };
    tlsCert = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      example = "/var/lib/dendrite/server.cert";
      default = null;
      description = ''
        The path to the TLS certificate.

        <programlisting>
          nix-shell -p dendrite --command "generate-keys --tls-cert server.crt --tls-key server.key"
        </programlisting>
      '';
    };
    tlsKey = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      example = "/var/lib/dendrite/server.key";
      default = null;
      description = ''
        The path to the TLS key.

        <programlisting>
          nix-shell -p dendrite --command "generate-keys --tls-cert server.crt --tls-key server.key"
        </programlisting>
      '';
    };
    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      example = "/var/lib/dendrite/registration_secret";
      default = null;
      description = ''
        Environment file as defined in <citerefentry>
        <refentrytitle>systemd.exec</refentrytitle><manvolnum>5</manvolnum>
        </citerefentry>.
        Secrets may be passed to the service without adding them to the world-readable
        Nix store, by specifying placeholder variables as the option value in Nix and
        setting these variables accordingly in the environment file. Currently only used
        for the registration secret to allow secure registration when
        client_api.registration_disabled is true.

        <programlisting>
          # snippet of dendrite-related config
          services.dendrite.settings.client_api.registration_shared_secret = "$REGISTRATION_SHARED_SECRET";
        </programlisting>

        <programlisting>
          # content of the environment file
          REGISTRATION_SHARED_SECRET=verysecretpassword
        </programlisting>

        Note that this file needs to be available on the host on which
        <literal>dendrite</literal> is running.
      '';
    };
    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options.global = {
          server_name = lib.mkOption {
            type = lib.types.str;
            example = "example.com";
            description = ''
              The domain name of the server, with optional explicit port.
              This is used by remote servers to connect to this server.
              This is also the last part of your UserID.
            '';
          };
          private_key = lib.mkOption {
            type = lib.types.path;
            example = "${workingDir}/matrix_key.pem";
            description = ''
              The path to the signing private key file, used to sign
              requests and events.

              <programlisting>
                nix-shell -p dendrite --command "generate-keys --private-key matrix_key.pem"
              </programlisting>
            '';
          };
          trusted_third_party_id_servers = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            example = [ "matrix.org" ];
            default = [ "matrix.org" "vector.im" ];
            description = ''
              Lists of domains that the server will trust as identity
              servers to verify third party identifiers such as phone
              numbers and email addresses
            '';
          };
        };
        options.client_api = {
          registration_disabled = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = ''
              Whether to disable user registration to the server
              without the shared secret.
            '';
          };
        };
      };
      default = { };
      description = ''
        Configuration for dendrite, see:
        <link xlink:href="https://github.com/matrix-org/dendrite/blob/master/dendrite-config.yaml"/>
        for available options with which to populate settings.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [{
      assertion = cfg.httpsPort != null -> (cfg.tlsCert != null && cfg.tlsKey != null);
      message = ''
        If Dendrite is configured to use https, tlsCert and tlsKey must be provided.

        nix-shell -p dendrite --command "generate-keys --tls-cert server.crt --tls-key server.key"
      '';
    }];

    systemd.services.dendrite = {
      description = "Dendrite Matrix homeserver";
      after = [
        "network.target"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        StateDirectory = "dendrite";
        WorkingDirectory = workingDir;
        RuntimeDirectory = "dendrite";
        RuntimeDirectoryMode = "0700";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        ExecStartPre =
          if (cfg.environmentFile != null) then ''
            ${pkgs.envsubst}/bin/envsubst \
              -i ${configurationYaml} \
              -o /run/dendrite/dendrite.yaml
          '' else ''
            ${pkgs.coreutils}/bin/cp ${configurationYaml} /run/dendrite/dendrite.yaml
          '';
        ExecStart = lib.strings.concatStringsSep " " ([
          "${pkgs.dendrite}/bin/dendrite-monolith-server"
          "--config /run/dendrite/dendrite.yaml"
        ] ++ lib.optionals (cfg.httpPort != null) [
          "--http-bind-address :${builtins.toString cfg.httpPort}"
        ] ++ lib.optionals (cfg.httpsPort != null) [
          "--https-bind-address :${builtins.toString cfg.httpsPort}"
          "--tls-cert ${cfg.tlsCert}"
          "--tls-key ${cfg.tlsKey}"
        ]);
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        Restart = "on-failure";
      };
    };
  };
  meta.maintainers = lib.teams.matrix.members;
}
