# Gel database server.
#
# Minimal service: runs gel-server against a local data directory with a
# file-provided admin password applied once at bootstrap. No trust-auth
# mode, no ambient credentials.
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.gel-server;
in {
  options.services.gel-server = {
    enable = lib.mkEnableOption "Gel database server";

    package = lib.mkPackageOption pkgs "gel-server" {};

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/gel-server";
      description = "Database cluster directory.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5656;
      description = "Port to listen on.";
    };

    bindAddress = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address to listen on. Loopback unless TLS is reviewed.";
    };

    passwordFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        File containing the admin password, applied once when the cluster
        is first bootstrapped. Read at runtime, never copied to the store.
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "gel-server";
      description = "User the server runs as.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "gel-server";
      description = "Group the server runs as.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users = lib.mkIf (cfg.user == "gel-server") {
      gel-server = {
        isSystemUser = true;
        group = cfg.group;
        description = "Gel database server";
      };
    };
    users.groups = lib.mkIf (cfg.group == "gel-server") {
      gel-server = {};
    };

    systemd.services.gel-server = {
      description = "Gel database server";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];

      preStart = ''
        mkdir -p "${cfg.dataDir}"
        chown ${cfg.user}:${cfg.group} "${cfg.dataDir}"
        chmod 0700 "${cfg.dataDir}"
        # First boot only: bootstrap the cluster with the admin password
        # from the password file. EdgeQL single-quote escaping by doubling.
        if [ ! -e "${cfg.dataDir}/PG_VERSION" ]; then
          pass="$(cat "${cfg.passwordFile}")"
          esc_pass="$(printf '%s' "$pass" | sed "s/'/'''/g")"
          printf "ALTER ROLE admin SET password := '%s';" "$esc_pass" \
            > "${cfg.dataDir}/bootstrap-admin.edgeql"
          chmod 600 "${cfg.dataDir}/bootstrap-admin.edgeql"
          ${lib.getExe cfg.package} \
            -D "${cfg.dataDir}" \
            --bootstrap-only \
            --bootstrap-command-file "${cfg.dataDir}/bootstrap-admin.edgeql"
          rm -f "${cfg.dataDir}/bootstrap-admin.edgeql"
        fi
        chown -R ${cfg.user}:${cfg.group} "${cfg.dataDir}"
      '';

      serviceConfig = {
        ExecStart = ''
          ${lib.getExe cfg.package} \
            -D "${cfg.dataDir}" \
            -P ${toString cfg.port} \
            -I "${cfg.bindAddress}" \
            --tls-cert-mode=generate_self_signed
        '';
        User = cfg.user;
        Group = cfg.group;
        # The server manages its postgres cluster itself (bundled fork
        # binaries); no external database needed.
      };
    };
  };
}
