{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.matrix-appservice-irc;

  defaultConfig = {
    database = {
      engine = "nedb";
      connectionString = "nedb://var/lib/matrix-appservice-irc/data";
    };
    ircService.passwordEncryptionKeyPath = "/var/lib/matrix-appservice-irc/passkey.pem";
  };
  configFile = pkgs.writeText "matrix-appservice-irc.yml" (builtins.toJSON (recursiveUpdate cfg.config defaultConfig));
  bin = "${pkgs.matrix-appservice-irc}/bin/matrix-appservice-irc";
  registrationFile = "/var/lib/matrix-appservice-irc/registration.yml";
in {
  options.services.matrix-appservice-irc = with types; {
    enable = mkEnableOption "the Matrix/IRC bridge";

    port = mkOption {
      type = port;
      description = "The port to listen on";
      default = 8009;
    };

    needBindingCap = mkOption {
      type = bool;
      description = "Whether the daemon needs to bind to ports less than 1024 (e.g. for the ident service)";
      default = false;
    };

    passwordKeyLength = mkOption {
      type = ints.unsigned;
      description = "Length of te key to encrypt IRC passwords";
      default = 2048;
      example = 8192;
    };

    registrationUrl = mkOption {
      type = str;
      description = "The URL where the application service is listening for HS requests";
      example = "http://localhost:8009";
    };

    localpart = mkOption {
      type = str;
      description = "The user_id localpart to assign to the AS";
      default = "appservice-irc";
    };

    config = mkOption {
      type = attrs;
      description = "Configuration for the appservice";
      default = {};
    };
  };
  config = mkIf cfg.enable {
    systemd.services.matrix-appservice-irc = {
      description = "Matrix-IRC bridge";
      before = [ "matrix-synapse.service" ]; # So the registration can be used by Synapse
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        mask="$(umask)"
        umask 077

        # Generate key for crypting passwords
        if ! [ -f "${defaultConfig.ircService.passwordEncryptionKeyPath}" ]; then
          ${pkgs.openssl}/bin/openssl genpkey -out "${defaultConfig.ircService.passwordEncryptionKeyPath}" -outform PEM -algorithm RSA -pkeyopt "rsa_keygen_bits:${toString cfg.passwordKeyLength}"
        fi

        # Generate registration
        if ! [ -f "${registrationFile}" ]; then
          ${bin} -c ${configFile} -f ${registrationFile} -r -u ${cfg.registrationUrl} -l ${cfg.localpart}
        fi

        # Allow synapse access to the registration
        if ${getBin pkgs.glibc}/bin/getent group matrix-synapse > /dev/null; then
          chgrp matrix-synapse ${registrationFile}
          chmod g+r ${registrationFile}
        fi
      '';

      serviceConfig = rec {
        Type = "simple";
        ExecStart = "${bin} -c ${configFile} -f ${registrationFile} -p ${toString cfg.port}";

        ProtectHome = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        StateDirectory = "matrix-appservice-irc";
        StateDirectoryMode = "755";

        User = "appservice-matrix-irc";
        Group = "appservice-matrix-irc";

        CapabilityBoundingSet = if cfg.needBindingCap then "CAP_CHOWN CAP_NET_BIND_SERVICE" else "CAP_CHOWN";
        AmbientCapabilities = CapabilityBoundingSet;
        NoNewPrivileges = true;

        LockPersonality = true;
        RestrictRealtime = true;
        PrivateMounts = true;
        SystemCallFilter = "~@aio @clock @cpu-emulation @debug @keyring @memlock @module @mount @obsolete @raw-io @setuid @swap";
        SystemCallArchitectures = "native";
        RestrictAddressFamilies = "AF_INET AF_INET6";
      };
    };

    users.groups.appservice-matrix-irc = {};
    users.users.appservice-matrix-irc = {
      description = "Service user for the Matrix-IRC bridge";
      group = "appservice-matrix-irc";
      isSystemUser = true;
    };
  };
}
