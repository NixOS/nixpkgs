{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.programs.goldwarden;
in
{
  options.programs.goldwarden = {
    enable = lib.mkEnableOption "Goldwarden";
    package = lib.mkPackageOption pkgs "goldwarden" { };
    useSshAgent = lib.mkEnableOption "Goldwarden's SSH Agent" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      etc = lib.mkIf config.programs.chromium.enable {
        "chromium/native-messaging-hosts/com.8bit.bitwarden.json".source =
          "${cfg.package}/etc/chromium/native-messaging-hosts/com.8bit.bitwarden.json";
        "opt/chrome/native-messaging-hosts/com.8bit.bitwarden.json".source =
          "${cfg.package}/etc/chrome/native-messaging-hosts/com.8bit.bitwarden.json";
      };

      variables.SSH_AUTH_SOCK = builtins.addErrorContext "while setting SSH_AUTH_SOCK, did you enable another agent already?" (
        lib.optionalString cfg.useSshAgent (lib.mkDefault "$HOME/.goldwarden-ssh-agent.sock")
      );

      systemPackages = [
        # for cli and polkit action
        cfg.package
        # binary exec's into pinentry which should match the DE
        config.programs.gnupg.agent.pinentryPackage
      ];
    };

    programs.firefox.nativeMessagingHosts.packages = [ cfg.package ];

    # see https://github.com/quexten/goldwarden/blob/main/cmd/goldwarden.service
    systemd.user.services.goldwarden = {
      description = "Goldwarden daemon";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig.ExecStart = "${lib.getExe cfg.package} daemonize";
      path = [ config.programs.gnupg.agent.pinentryPackage ];
      unitConfig.ConditionUser = "!@system";
    };
  };
}
