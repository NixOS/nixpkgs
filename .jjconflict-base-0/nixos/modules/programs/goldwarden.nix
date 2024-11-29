{ lib, config, pkgs, ... }:
let
  cfg = config.programs.goldwarden;
in
{
  options.programs.goldwarden = {
    enable = lib.mkEnableOption "Goldwarden";
    package = lib.mkPackageOption pkgs "goldwarden" {};
    useSshAgent = lib.mkEnableOption "Goldwarden's SSH Agent" // { default = true; };
  };

  config = lib.mkIf cfg.enable {
    assertions = [{
       assertion = cfg.useSshAgent -> !config.programs.ssh.startAgent;
       message = "Only one ssh-agent can be used at a time.";
    }];

    environment = {
      etc = lib.mkIf config.programs.chromium.enable {
        "chromium/native-messaging-hosts/com.8bit.bitwarden.json".source = "${cfg.package}/etc/chromium/native-messaging-hosts/com.8bit.bitwarden.json";
        "opt/chrome/native-messaging-hosts/com.8bit.bitwarden.json".source = "${cfg.package}/etc/chrome/native-messaging-hosts/com.8bit.bitwarden.json";
      };

      extraInit = lib.mkIf cfg.useSshAgent ''
        if [ -z "$SSH_AUTH_SOCK" -a -n "$HOME" ]; then
          export SSH_AUTH_SOCK="$HOME/.goldwarden-ssh-agent.sock"
        fi
      '';

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
