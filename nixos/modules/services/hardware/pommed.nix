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
        description = ''
          Whether to use the pommed tool to handle Apple laptop
          keyboard hotkeys.
        '';
      };

      configFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          The path to the <filename>pommed.conf</filename> file. Leave
          to null to use the default config file
          (<filename>/etc/pommed.conf.mactel</filename>). See the
          files <filename>/etc/pommed.conf.mactel</filename> and
          <filename>/etc/pommed.conf.pmac</filename> for examples to
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
