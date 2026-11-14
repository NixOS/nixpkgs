{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.playit;
in
{
  options.services.playit = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable the playit agent, which tunnels local game servers to the internet.

        Tunnels and their public addresses are configured on the
        [playit.gg website](https://playit.gg/account/tunnels), not in this module.
      '';
    };

    package = lib.mkPackageOption pkgs "playit" { };

    secretPath = lib.mkOption {
      type = lib.types.path;
      example = lib.literalExpression "/etc/playit/secret.toml";
      description = ''
        Path to a TOML file containing the playit agent secret.
        Loaded via systemd's `LoadCredential` directive,
        so the file permissions can be tightened to `0400` and owned by any user.

        ::: {.note}
        The secret is created with the agent's claim flow. `playit-cli` is installed
        by this module, but the module needs the secret before it can be enabled,
        so run the claim flow like this instead:

        ```bash
        nix shell nixpkgs#playit -c playit-cli claim generate
        nix shell nixpkgs#playit -c playit-cli claim exchange <claim-code>
        ```

        Open the printed link, approve the agent in the browser, and copy the
        secret it prints once the agent is approved.
        Put it in a TOML file like this:

        ```toml
        secret_key = "<secret>"
        ```
        :::
      '';
    };

    logrotate = {
      enable = lib.mkEnableOption "the logrotate rule for playit logs" // {
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.playit = {
      description = "Playit.gg agent";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        ExecStart = lib.concatStringsSep " " [
          (lib.getExe' cfg.package "playitd")
          "--secret-path"
          "\${CREDENTIALS_DIRECTORY}/secret"
          "--log-path"
          "\${LOGS_DIRECTORY}/playit.log"
          "--cert-dir"
          "\${STATE_DIRECTORY}/certs"
        ];
        Restart = "on-failure";
        LogsDirectory = "playit";
        RuntimeDirectory = "playit";
        RuntimeDirectoryMode = "0755";
        StateDirectory = "playit";
        StateDirectoryMode = "0700";

        LoadCredential = [
          "secret:${cfg.secretPath}"
        ];

        # Hardening
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        DeviceAllow = [ "" ];
        LockPersonality = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        PrivateIPC = true;
        DynamicUser = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectHostname = true;
        ProtectProc = "invisible";
        RestrictSUIDSGID = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        ProtectClock = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        NoNewPrivileges = true;
        CapabilityBoundingSet = [ "" ];
      };
    };

    services.logrotate.settings = lib.mkIf cfg.logrotate.enable {
      # Mirroring https://github.com/playit-cloud/playit-agent/blob/bddcbed5e31e697f3b5793dedc05e934faaf6207/linux/logrotate.conf
      playit = {
        enable = true;
        files = "/var/log/playit/playit.log";
        frequency = "daily";
        rotate = 3;
        missingok = true;
        copytruncate = true;
        compress = true;
        notifempty = true;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ pedorich-n ];
}
