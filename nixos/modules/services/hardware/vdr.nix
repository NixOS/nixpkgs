{ config, lib, pkgs, ... }:
let
  cfg = config.services.vdr;

  inherit (lib)
    mkEnableOption mkPackageOption mkOption types mkIf optional;
in
{
  options = {

    services.vdr = {
      enable = mkEnableOption "VDR, a video disk recorder";

      package = mkPackageOption pkgs "vdr" {
        example = "wrapVdr.override { plugins = with pkgs.vdrPlugins; [ hello ]; }";
      };

      videoDir = mkOption {
        type = types.path;
        default = "/srv/vdr/video";
        description = "Recording directory";
      };

      extraArguments = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Additional command line arguments to pass to VDR.";
      };

      enableLirc = mkEnableOption "LIRC";

      user = mkOption {
        type = types.str;
        default = "vdr";
        description = ''
          User under which the VDR service runs.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "vdr";
        description = ''
          Group under which the VDRvdr service runs.
        '';
      };
    };

  };

  config = mkIf cfg.enable {

    systemd.tmpfiles.rules = [
      "d ${cfg.videoDir} 0755 ${cfg.user} ${cfg.group} -"
      "Z ${cfg.videoDir} - ${cfg.user} ${cfg.group} -"
    ];

    systemd.services.vdr = {
      description = "VDR";
      wantedBy = [ "multi-user.target" ];
      wants = optional cfg.enableLirc "lircd.service";
      after = [ "network.target" ]
        ++ optional cfg.enableLirc "lircd.service";
      serviceConfig = {
        ExecStart =
          let
            args = [
              "--video=${cfg.videoDir}"
            ]
            ++ optional cfg.enableLirc "--lirc=${config.passthru.lirc.socket}"
            ++ cfg.extraArguments;
          in
          "${cfg.package}/bin/vdr ${lib.escapeShellArgs args}";
        User = cfg.user;
        Group = cfg.group;
        CacheDirectory = "vdr";
        StateDirectory = "vdr";
        RuntimeDirectory = "vdr";
        Restart = "on-failure";
      };
    };

    environment.systemPackages = [ cfg.package ];

    users.users = mkIf (cfg.user == "vdr") {
      vdr = {
        inherit (cfg) group;
        home = "/run/vdr";
        isSystemUser = true;
        extraGroups = [
          "video"
          "audio"
        ]
        ++ optional cfg.enableLirc "lirc";
      };
    };

    users.groups = mkIf (cfg.group == "vdr") { vdr = { }; };

  };
}
