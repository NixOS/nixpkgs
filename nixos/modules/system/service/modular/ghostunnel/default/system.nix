{ lib, config, ... }:
let
  inherit (lib) optional concatStringsSep;
  cfg = config.ghostunnel;
  # Build credential flags with systemd variable substitution
  credentialFlags = concatStringsSep " " (
    optional (cfg.keystore != null) "--keystore=\${CREDENTIALS_DIRECTORY}/keystore"
    ++ optional (cfg.cert != null) "--cert=\${CREDENTIALS_DIRECTORY}/cert"
    ++ optional (cfg.key != null) "--key=\${CREDENTIALS_DIRECTORY}/key"
    ++ optional (cfg.cacert != null) "--cacert=\${CREDENTIALS_DIRECTORY}/cacert"
  );
in
{
  _class = "service";
  imports = [ ./default.nix ];
  config = {
    # Use mainExecStart to add credential flags with systemd variable substitution
    systemd.mainExecStart =
      config.systemd.lib.escapeSystemdExecArgs config.process.argv
      + lib.optionalString (credentialFlags != "") " ${credentialFlags}";

    systemd.service = {
      after = [ "network.target" ];
      wants = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Restart = "always";
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        DynamicUser = true;
        LoadCredential =
          optional (cfg.keystore != null) "keystore:${cfg.keystore}"
          ++ optional (cfg.cert != null) "cert:${cfg.cert}"
          ++ optional (cfg.key != null) "key:${cfg.key}"
          ++ optional (cfg.cacert != null) "cacert:${cfg.cacert}";
      };
    };
  };
}
