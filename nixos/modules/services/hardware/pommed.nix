{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.hardware.pommed;
    defaultConf = "${pkgs.pommed_light}/etc/pommed.conf.mactel";
in {

  options = {

    services.hardware.pommed = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to use the pommed tool to handle Apple laptop
          keyboard hotkeys.
        '';
      };

      configFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc ''
          The path to the {file}`pommed.conf` file. Leave
          to null to use the default config file
          ({file}`/etc/pommed.conf.mactel`). See the
          files {file}`/etc/pommed.conf.mactel` and
          {file}`/etc/pommed.conf.pmac` for examples to
          build on.
        '';
      };
    };

  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.polkit pkgs.pommed_light ];

    environment.etc."pommed.conf".source =
      if cfg.configFile == null then defaultConf else cfg.configFile;

    systemd.services.pommed = {
      description = "Pommed Apple Hotkeys Daemon";
      wantedBy = [ "multi-user.target" ];
      script = "${pkgs.pommed_light}/bin/pommed -f";
    };
  };
}
