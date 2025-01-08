{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.vdr;

  inherit (lib)
    mkEnableOption
    mkPackageOption
    lib.mkOption
    types
    mkIf
    lib.optional
    ;
in
{
  options = {

    services.vdr = {
      enable = lib.mkEnableOption "VDR, a video disk recorder";

      package = lib.mkPackageOption pkgs "vdr" {
        example = "wrapVdr.override { plugins = with pkgs.vdrPlugins; [ hello ]; }";
      };

      videoDir = lib.mkOption {
        type = lib.types.path;
        default = "/srv/vdr/video";
        description = "Recording directory";
      };

      extraArguments = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Additional command line arguments to pass to VDR.";
      };

      enableLirc = mkEnableOption "LIRC";

      user = lib.mkOption {
        type = lib.types.str;
        default = "vdr";
        description = ''
          User under which the VDR service runs.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "vdr";
        description = ''
          Group under which the VDRvdr service runs.
        '';
      };
    };

  };

  config = lib.mkIf cfg.enable {

    systemd.tmpfiles.rules = [
      "d ${cfg.videoDir} 0755 ${cfg.user} ${cfg.group} -"
      "Z ${cfg.videoDir} - ${cfg.user} ${cfg.group} -"
    ];

    systemd.services.vdr = {
      description = "VDR";
      wantedBy = [ "multi-user.target" ];
      wants = lib.optional cfg.enableLirc "lircd.service";
      after = [ "network.target" ] ++ lib.optional cfg.enableLirc "lircd.service";
      serviceConfig = {
        ExecStart =
          let
            args =
              [
                "--video=${cfg.videoDir}"
              ]
              ++ lib.optional cfg.enableLirc "--lirc=${config.passthru.lirc.socket}"
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

    users.users = lib.mkIf (cfg.user == "vdr") {
      vdr = {
        inherit (cfg) group;
        home = "/run/vdr";
        isSystemUser = true;
        extraGroups = [
          "video"
          "audio"
        ] ++ lib.optional cfg.enableLirc "lirc";
      };
    };

    users.groups = lib.mkIf (cfg.group == "vdr") { vdr = { }; };

  };
}
