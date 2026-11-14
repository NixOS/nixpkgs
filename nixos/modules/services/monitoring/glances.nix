{
  pkgs,
  config,
  lib,
  utils,
  ...
}:
let
  cfg = config.services.glances;

  inherit (lib)
    escapeShellArg
    getExe
    maintainers
    mkEnableOption
    mkOption
    mkIf
    mkPackageOption
    optionalString
    ;

  inherit (lib.types)
    bool
    listOf
    nullOr
    path
    port
    str
    ;

  inherit (utils)
    escapeSystemdExecArg
    escapeSystemdExecArgs
    ;

in
{
  options.services.glances = {
    enable = mkEnableOption "Glances";

    package = mkPackageOption pkgs "glances" { };

    port = mkOption {
      description = "Port the server will isten on.";
      type = port;
      default = 61208;
    };

    username = mkOption {
      description = ''
        Username the clients use to authenticate against the glances web or
        server interface. Only relevant when {option}`passwordFile` is set.
      '';
      type = str;
      default = "glances";
    };

    passwordFile = mkOption {
      description = ''
        Path to a file that contains the plain-text password used to protect
        the glances web or server interface. The default username is
        {option}`username`.

        Provide the password this way to keep it out of the nix store, for
        example with sops-secrets or agenix. The module reads it from the
        secret file and hashes it in a pre-start step.

        When you set your own configuration file through {option}`extraArgs`,
        make sure it does not define `local_password_path` in the
        `[passwords]` section.
      '';
      type = nullOr path;
      default = null;
      example = "/run/secrets/glances/password";
    };

    openFirewall = mkOption {
      description = "Open port in the firewall for glances.";
      type = bool;
      default = false;
    };

    extraArgs = mkOption {
      type = listOf str;
      default = [ "--webserver" ];
      example = [
        "--webserver"
        "--disable-webui"
      ];
      description = ''
        Extra command-line arguments to pass to glances.

        See <https://glances.readthedocs.io/en/latest/cmds.html> for all available options.
      '';
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    systemd.services."glances" = {
      description = "Glances";
      documentation = [ "man:glances(1)" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        ExecStart = "${getExe cfg.package} --port ${toString cfg.port} ${escapeSystemdExecArgs cfg.extraArgs}${
          optionalString (cfg.passwordFile != null) " -u ${escapeSystemdExecArg cfg.username} --password"
        }";
        ExecStartPre = mkIf (cfg.passwordFile != null) (
          pkgs.writeShellScript "glances-password" ''
            # Restrict the hashed password file to the service account
            umask 077
            mkdir -p /run/glances/glances
            ${getExe pkgs.python3} - \
              '/run/glances/glances/${escapeShellArg cfg.username}.pwd' \
              /run/credentials/glances.service/glances-password <<'PYEOF'
            import hashlib
            import os
            import sys
            import uuid

            with open(sys.argv[2], "rb") as secret:
                password = secret.read().rstrip(b"\r\n")

            salt = uuid.uuid4().hex
            digest = hashlib.pbkdf2_hmac("sha256", password, salt.encode(), 100000, dklen=128).hex()
            os.makedirs(os.path.dirname(sys.argv[1]), mode=0o700, exist_ok=True)
            with open(sys.argv[1], "w") as pwd:
                pwd.write(salt + "$" + digest)
            PYEOF
          ''
        );
        Environment = mkIf (cfg.passwordFile != null) [ "XDG_CONFIG_HOME=/run/glances" ];
        LoadCredential = mkIf (cfg.passwordFile != null) [ "glances-password:${cfg.passwordFile}" ];
        RuntimeDirectory = mkIf (cfg.passwordFile != null) "glances";
        Restart = "on-failure";

        NoNewPrivileges = true;
        ProtectSystem = "full";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        MemoryDenyWriteExecute = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_UNIX"
        ];
        LockPersonality = true;
        RestrictRealtime = true;
        ProtectClock = true;
        ReadWritePaths = [ "/var/log" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        SystemCallFilter = [ "@system-service" ];
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];
  };

  meta.maintainers = with maintainers; [ claha ];
}
