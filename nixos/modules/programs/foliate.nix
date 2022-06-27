{ lib, pkgs, config, ... }:

with lib; {
  options.programs.foliate = {
    enable = mkEnableOption "Foliate - A simple and modern eBook reader.";

    extraConfig = mkOption {
      description = "Additional options to put verbatim into Foliate's config file.";
      type = types.lines;
      default = ''
        [com/github/johnfactotum/Foliate]
      '';
      example = ''
        [com/github/johnfactotum/Foliate]
        # Choose between: location, percentage, time-left-book, time-left-section, section-name
        footer-left='location'
        footer-right='section-name'

        [com/github/johnfactotum/Foliate/view]
        # Dark theme
        bg-color='#000000'
        fg-color='#FFFFFF'
        link-color='#00FFFF'

        # Choose between: auto, scrolled, continuous, single
        layout='continuous'

        # Any integer >= 0
        margin=0

        # Between 1.0 and 3.0
        spacing=1.0

        # Uncomment to set a custom font and font size:
        # font='Fira Code 16'
      '';
    };
  };
  config = lib.mkIf config.programs.foliate.enable {
    environment.systemPackages = [ pkgs.foliate ];

    programs.dconf.enable = true;
    programs.dconf.packages = [
      (pkgs.writeTextFile {
        name = "dconf-user-profile";
        destination = "/etc/dconf/profile/user";
        text = ''
          user-db:user
          system-db:site
        '';
      })
      (pkgs.writeTextFile {
        name = "dconf-foliate-settings";
        destination = "/etc/dconf/db/site.d/00_foliate_settings";
        text = config.programs.foliate.extraConfig;
      })
    ];
  };
}
