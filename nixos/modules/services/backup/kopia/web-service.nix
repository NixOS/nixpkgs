{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.kopia;
  helpers = import ./helpers.nix { inherit lib; };
in
{
  options.services.kopia.backups = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options.web = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              Whether to enable the Kopia web UI server.
            '';
          };

          address = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1:51515";
            description = ''
              Address and port for the Kopia web server to listen on.
            '';
          };

          serverUsername = lib.mkOption {
            type = lib.types.str;
            default = "kopia";
            description = ''
              Username for the Kopia web server (basic auth).
            '';
          };

          serverPasswordFile = lib.mkOption {
            type = with lib.types; nullOr str;
            default = null;
            description = ''
              Path to a file containing the password for the Kopia web
              server.

              For tests or examples, this can be provided with a store path:

              ```nix
              serverPasswordFile = pkgs.writeText "kopia-web-password" "my-super-safe-secret";
              ```

              This still stores the password in the Nix store. For production
              secrets, prefer a runtime secret file such as `/run/secrets/...`.
            '';
          };

          tlsCertFile = lib.mkOption {
            type = with lib.types; nullOr str;
            default = null;
            description = ''
              Path to a TLS certificate file for the Kopia web server.
            '';
          };

          tlsKeyFile = lib.mkOption {
            type = with lib.types; nullOr str;
            default = null;
            description = ''
              Path to a TLS key file for the Kopia web server.
            '';
          };
        };
      }
    );
  };

  config = lib.mkIf (cfg.backups != { }) {
    assertions = lib.flatten (
      lib.mapAttrsToList (name: backup: [
        {
          assertion = backup.web.enable -> backup.web.serverPasswordFile != null;
          message = "services.kopia.backups.${name}: web.serverPasswordFile must be set when web.enable is true";
        }
        {
          assertion = (backup.web.tlsCertFile != null) == (backup.web.tlsKeyFile != null);
          message = "services.kopia.backups.${name}: web.tlsCertFile and web.tlsKeyFile must be set together: specify both to enable TLS, or neither to disable it";
        }
      ]) cfg.backups
    );

    systemd.services = lib.mapAttrs' (
      name: backup:
      let
        kopiaExe = lib.getExe cfg.package;
        tlsArgs =
          if backup.web.tlsCertFile != null then
            "--tls-cert-file ${lib.escapeShellArg backup.web.tlsCertFile} --tls-key-file ${lib.escapeShellArg backup.web.tlsKeyFile}"
          else
            "--insecure";
        webScript = pkgs.writeShellScript "kopia-web-${name}" ''
          set -euo pipefail
          export KOPIA_PASSWORD="$(cat ${lib.escapeShellArg backup.passwordFile})"
          export KOPIA_SERVER_USERNAME=${lib.escapeShellArg backup.web.serverUsername}
          export KOPIA_SERVER_PASSWORD="$(cat ${lib.escapeShellArg backup.web.serverPasswordFile})"

          exec ${kopiaExe} server start ${tlsArgs} --address ${lib.escapeShellArg backup.web.address}
        '';
      in
      lib.nameValuePair "kopia-web-${name}" {
        description = "Kopia web UI for ${name}";
        requires = [ "kopia-repository-${name}.service" ];
        after = [ "kopia-repository-${name}.service" ];
        wantedBy = [ "multi-user.target" ];
        environment = {
          KOPIA_CONFIG_PATH = "/var/lib/kopia/${name}/repository.config";
        };
        serviceConfig = {
          Type = "oneshot";
          User = backup.user;
          StateDirectory = "kopia/${name}";
          PrivateTmp = true;
          NoNewPrivileges = true;
          ProtectSystem = "strict";
          ReadWritePaths = [
            "/var/lib/kopia/${name}"
          ]
          ++ lib.optional (backup.repository ? filesystem) backup.repository.filesystem.path;
        }
        // {
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 30;
          ExecStart = webScript;
        };
      }
    ) (lib.filterAttrs (_: b: b.web.enable) cfg.backups);
  };
}
