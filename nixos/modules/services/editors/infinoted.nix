{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.infinoted;
in
{
  options.services.infinoted = {
    enable = mkEnableOption "infinoted";

    package = mkPackageOption pkgs "libinfinity" { };

    keyFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Private key to use for TLS
      '';
    };

    certificateFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Server certificate to use for TLS
      '';
    };

    certificateChain = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Chain of CA-certificates to which our `certificateFile` is relative.
        Optional for TLS.
      '';
    };

    securityPolicy = mkOption {
      type = types.enum [
        "no-tls"
        "allow-tls"
        "require-tls"
      ];
      default = "require-tls";
      description = ''
        How strictly to enforce clients connection with TLS.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 6523;
      description = ''
        Port to listen on
      '';
    };

    rootDirectory = mkOption {
      type = types.path;
      default = "/var/lib/infinoted/documents/";
      description = ''
        Root of the directory structure to serve
      '';
    };

    plugins = mkOption {
      type = types.listOf types.str;
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

    passwordFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        File to read server-wide password from
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = ''
        [autosave]
        interval=10
      '';
      description = ''
        Additional configuration to append to infinoted.conf
      '';
    };

    user = mkOption {
      type = types.str;
      default = "infinoted";
      description = ''
        What to call the dedicated user under which infinoted is run
      '';
    };

    group = mkOption {
      type = types.str;
      default = "infinoted";
      description = ''
        What to call the primary group of the dedicated user under which infinoted is run
      '';
    };
  };

  config = mkIf (cfg.enable) {
    users.users = optionalAttrs (cfg.user == "infinoted") {
      infinoted = {
        description = "Infinoted user";
        group = cfg.group;
        isSystemUser = true;
      };
    };
    users.groups = optionalAttrs (cfg.group == "infinoted") {
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
        ${optionalString (cfg.keyFile != null) "key-file=${cfg.keyFile}"}
        ${optionalString (cfg.certificateFile != null) "certificate-file=${cfg.certificateFile}"}
        ${optionalString (cfg.certificateChain != null) "certificate-chain=${cfg.certificateChain}"}
        port=${toString cfg.port}
        security-policy=${cfg.securityPolicy}
        root-directory=${cfg.rootDirectory}
        plugins=${concatStringsSep ";" cfg.plugins}
        ${optionalString (cfg.passwordFile != null) "password=$(head -n 1 ${cfg.passwordFile})"}

        ${cfg.extraConfig}
        EOF

        install -o ${cfg.user} -g ${cfg.group} -m 0750 -d ${cfg.rootDirectory}
      '';
    };
  };
}
