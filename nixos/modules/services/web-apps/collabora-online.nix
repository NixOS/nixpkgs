{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.collabora-online;

  freeformType = lib.types.attrsOf ((pkgs.formats.json { }).type) // {
    description = ''
      `coolwsd.xml` configuration type, used to override values in the default configuration.

      Attribute names correspond to XML tags unless prefixed with `@`. Nested attribute sets
      correspond to nested XML tags. Attribute prefixed with `@` correspond to XML attributes. E.g.,
      `{ storage.wopi."@allow" = true; }` in Nix corresponds to
      `<storage><wopi allow="true"/></storage>` in `coolwsd.xml`, or `--o:storage.wopi[@allow]=true`
      in the command line.

      Arrays correspond to multiple elements with the same tag name. E.g.
      `{ host = [ '''127\.0\.0\.1''' "::1" ]; }` in Nix corresponds to
      ```xml
      <net><post_allow>
        <host>127\.0\.0\.1</host>
        <host>::1</host>
      </post_allow></net>
      ```
      in `coolwsd.xml`, or
      `--o:net.post_allow.host[0]='127\.0\.0\.1 --o:net.post_allow.host[1]=::1` in the command line.

      Null values could be used to remove an element from the default configuration.
    '';
  };

  configFile =
    pkgs.runCommandLocal "coolwsd.xml"
      {
        nativeBuildInputs = [
          pkgs.jq
          pkgs.yq-go
        ];
        userConfig = builtins.toJSON { config = cfg.settings; };
        passAsFile = [ "userConfig" ];
      }
      # Merge the cfg.settings into the default coolwsd.xml.
      # See https://github.com/CollaboraOnline/online/issues/10049.
      ''
        yq --input-format=xml \
           --xml-attribute-prefix=@ \
           --output-format=json \
           ${cfg.package}/etc/coolwsd/coolwsd.xml \
           > ./default_coolwsd.json

        jq '.[0] * .[1] | del(..|nulls)' \
           --slurp \
           ./default_coolwsd.json \
           $userConfigPath \
           > ./merged.json

        yq --output-format=xml \
           --xml-attribute-prefix=@ \
           ./merged.json \
           > $out
      '';
in
{
  options.services.collabora-online = {
    enable = lib.mkEnableOption "collabora-online";

    package = lib.mkPackageOption pkgs "Collabora Online" { default = "collabora-online"; };

    port = lib.mkOption {
      type = lib.types.port;
      default = 9980;
      description = "Listening port";
    };

    settings = lib.mkOption {
      type = freeformType;
      default = { };
      description = ''
        Configuration for Collabora Online WebSocket Daemon, see
        <https://sdk.collaboraonline.com/docs/installation/Configuration.html>, or
        <https://github.com/CollaboraOnline/online/blob/master/coolwsd.xml.in> for the default
        configuration.
      '';
    };

    aliasGroups = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            host = lib.mkOption {
              type = lib.types.str;
              example = "scheme://hostname:port";
              description = "Hostname to allow or deny.";
            };

            aliases = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              example = [
                "scheme://aliasname1:port"
                "scheme://aliasname2:port"
              ];
              description = "A list of regex pattern of aliasname.";
            };
          };
        }
      );
      default = [ ];
      description = "Alias groups to use.";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra arguments to pass to the service.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.collabora-online.settings = {
      child_root_path = lib.mkDefault "/var/lib/cool/child-roots";
      sys_template_path = lib.mkDefault "/var/lib/cool/systemplate";

      file_server_root_path = lib.mkDefault "${config.services.collabora-online.package}/share/coolwsd";

      # Use mount namespaces instead of setcap'd coolmount/coolforkit.
      mount_namespaces = lib.mkDefault true;

      # By default, use dummy self-signed certificates provided for testing.
      ssl.ca_file_path = lib.mkDefault "${config.services.collabora-online.package}/etc/coolwsd/ca-chain.cert.pem";
      ssl.cert_file_path = lib.mkDefault "${config.services.collabora-online.package}/etc/coolwsd/cert.pem";
      ssl.key_file_path = lib.mkDefault "${config.services.collabora-online.package}/etc/coolwsd/key.pem";
    };

    users.users.cool = {
      isSystemUser = true;
      group = "cool";
    };
    users.groups.cool = { };

    systemd.services.coolwsd-systemplate-setup = {
      description = "Collabora Online WebSocket Daemon Setup";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = utils.escapeSystemdExecArgs [
          "${cfg.package}/bin/coolwsd-systemplate-setup"
          "/var/lib/cool/systemplate"
          "${cfg.package.libreoffice}/lib/collaboraoffice"
        ];
        RemainAfterExit = true;
        StateDirectory = "cool";
        Type = "oneshot";
        User = "cool";
      };
    };

    systemd.services.coolwsd = {
      description = "Collabora Online WebSocket Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "coolwsd-systemplate-setup.service"
      ];

      environment = builtins.listToAttrs (
        lib.imap1 (n: ag: {
          name = "aliasgroup${toString n}";
          value = lib.concatStringsSep "," ([ ag.host ] ++ ag.aliases);
        }) cfg.aliasGroups
      );

      serviceConfig = {
        ExecStart = utils.escapeSystemdExecArgs (
          [
            "${cfg.package}/bin/coolwsd"
            "--config-file=${configFile}"
            "--port=${toString cfg.port}"
            "--use-env-vars"
            "--version"
          ]
          ++ cfg.extraArgs
        );
        KillMode = "mixed";
        KillSignal = "SIGINT";
        LimitNOFILE = "infinity:infinity";
        Restart = "always";
        StateDirectory = "cool";
        TimeoutStopSec = 120;
        User = "cool";
      };
    };
  };

  meta.maintainers = [ lib.maintainers.xzfc ];
}
