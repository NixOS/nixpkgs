# TODO for testing, remove before merging
# (and wait for a seaweedfs module in nixos)
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

        ${lib.getExe pkgs.seaweedfs} mini \
          -s3 \
          -dir="$STATE_DIRECTORY" \
          -master.telemetry=false \
          -bucket=${lib.join "," (lib.attrValues cfg.settings.s3.bucket)} \
          -admin.user="$(cat $CREDENTIALS_DIRECTORY/FLUXER_S3_ADMIN_USER)" \
          -admin.password="$(cat $CREDENTIALS_DIRECTORY/FLUXER_S3_ADMIN_PASS)" \
          -s3.config="$RUNTIME_DIRECTORY/config.json"
      '';

      environment = settingsToEnvVars cfg.settings;

      serviceConfig = {
        StateDirectory = "seaweedfs";
        RuntimeDirectory = "seaweedfs";
        RuntimeDirectoryMode = "0700";
        DynamicUser = true;
        LoadCredential = loadCredential cfg.settings;
      };
    };
  };
}
