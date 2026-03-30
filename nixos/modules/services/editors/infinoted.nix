{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.infinoted;
in
{
  options.services.infinoted = {
    enable = lib.mkEnableOption "infinoted";

    package = lib.mkPackageOption pkgs "libinfinity" { };

    keyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Private key to use for TLS
      '';
    };

    certificateFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Server certificate to use for TLS
      '';
    };

    certificateChain = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Chain of CA-certificates to which our `certificateFile` is relative.
        Optional for TLS.
      '';
    };

    securityPolicy = lib.mkOption {
      type = lib.types.enum [
        "no-tls"
        "allow-tls"
        "require-tls"
      ];
      default = "require-tls";
      description = ''
        How strictly to enforce clients connection with TLS.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 6523;
      description = ''
        Port to listen on
      '';
    };

    rootDirectory = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/infinoted/documents/";
      description = ''
        Root of the directory structure to serve
      '';
    };

    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "note-text"
        "note-chat"
        "logging"
        "autosave"
      ];
      description = ''
        Plugins to enable
      '';
    };

    passwordFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        File to read server-wide password from
      '';
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = ''
        [autosave]
        interval=10
      '';
      description = ''
        Additional configuration to append to infinoted.conf
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "infinoted";
      description = ''
        What to call the dedicated user under which infinoted is run
      '';
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "infinoted";
      description = ''
        What to call the primary group of the dedicated user under which infinoted is run
      '';
    };
  };

  config = lib.mkIf (cfg.enable) {
    users.users = lib.optionalAttrs (cfg.user == "infinoted") {
      infinoted = {
        description = "Infinoted user";
        group = cfg.group;
        isSystemUser = true;
      };
    };
    users.groups = lib.optionalAttrs (cfg.group == "infinoted") {
      infinoted = { };
    };

    systemd.services.infinoted = {
      description = "Gobby Dedicated Server";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${cfg.package.infinoted} --config-file=/var/lib/infinoted/infinoted.conf";
        User = cfg.user;
        Group = cfg.group;
        PermissionsStartOnly = true;
      };
      preStart = ''
        mkdir -p /var/lib/infinoted
        install -o ${cfg.user} -g ${cfg.group} -m 0600 /dev/null /var/lib/infinoted/infinoted.conf
        cat >>/var/lib/infinoted/infinoted.conf <<EOF
        [infinoted]
        ${lib.optionalString (cfg.keyFile != null) "key-file=${cfg.keyFile}"}
        ${lib.optionalString (cfg.certificateFile != null) "certificate-file=${cfg.certificateFile}"}
        ${lib.optionalString (cfg.certificateChain != null) "certificate-chain=${cfg.certificateChain}"}
        port=${toString cfg.port}
        security-policy=${cfg.securityPolicy}
        root-directory=${cfg.rootDirectory}
        plugins=${lib.concatStringsSep ";" cfg.plugins}
        ${lib.optionalString (cfg.passwordFile != null) "password=$(head -n 1 ${cfg.passwordFile})"}

        ${cfg.extraConfig}
        EOF

        install -o ${cfg.user} -g ${cfg.group} -m 0750 -d ${cfg.rootDirectory}
      '';
    };
  };
}
