{
  settingsToEnvVars,
  loadCredential,
  ...
}:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.services.fluxer;
in
{
  config = mkIf (cfg.enable && cfg.aux.seaweedfs.enable) {
    systemd.services.seaweedfs = {
      enable = true;
      wantedBy = [ "network-online.target" ];
      script = ''
        set -u
        set -o pipefail

        cat > $RUNTIME_DIRECTORY/config.json <<EOF
        {
          "identities": [
            {
              "name": "fluxer",
              "credentials": [
                {
                  "accessKey": "$(cat $CREDENTIALS_DIRECTORY/FLUXER_S3_ACCESS_KEY_ID_FILE)",
                  "secretKey": "$(cat $CREDENTIALS_DIRECTORY/FLUXER_S3_SECRET_ACCESS_KEY_FILE)"
                }
              ],
              "actions": ["Admin", "Read", "Write", "List", "Tagging"]
            }
          ]
        }
        EOF

        ADMIN_USER="$(cat $CREDENTIALS_DIRECTORY/s3_admin_user)"
        ADMIN_PASS="$(cat $CREDENTIALS_DIRECTORY/s3_admin_pass)"

        ${lib.getExe pkgs.seaweedfs} mini \
          -s3 \
          -dir="$STATE_DIRECTORY" \
          -master.telemetry=false \
          -bucket=${lib.join "," (lib.attrValues cfg.settings.s3.bucket)} \
          -admin.user="$ADMIN_USER" \
          -admin.password="$ADMIN_PASS" \
          -s3.config="$RUNTIME_DIRECTORY/config.json"
      '';

      environment = settingsToEnvVars cfg.settings;

      serviceConfig = {
        StateDirectory = "seaweedfs";
        RuntimeDirectory = "seaweedfs";
        RuntimeDirectoryMode = "0700";
        DynamicUser = true;
        LoadCredential = (loadCredential cfg.settings) ++ [
          "s3_admin_user:${cfg.aux.seaweedfs.admin_user_file}"
          "s3_admin_pass:${cfg.aux.seaweedfs.admin_pass_file}"
        ];
      };
    };
  };
}
