{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.audio-share;
  inherit
    (lib)
    maintainers
    getExe
    mkEnableOption
    mkPackageOption
    mkIf
    mkOption
    ;
  inherit
    (lib.types)
    bool
    listOf
    str
    ;
in {
  options.services.audio-share = {
    enable = mkEnableOption "audio-share";
    package = mkPackageOption pkgs "audio-share" {};
    openFirewall = mkOption {
      description = "Open port in the firewall.";
      type = bool;
      default = false;
    };
    extraArgs = mkOption {
      type = listOf str;
      default = [];
      description = "Extra command-line arguments.";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
    systemd.user.services."audio-share" = {
      description = "audio-share";
      after = ["pipewire.service" "sound.target"];
      wants = ["sound.target"];
      wantedBy = ["default.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${getExe cfg.package} -b";
        Restart = "on-failure";
      };
    };
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [65530];
    networking.firewall.allowedUDPPorts = mkIf cfg.openFirewall [65530];
  };
  meta.maintainers = with maintainers; [wetrustinprize];
}
