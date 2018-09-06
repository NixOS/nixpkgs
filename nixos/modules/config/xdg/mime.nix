{ config, lib, pkgs, ... }:

with lib;
{
  options = {
    xdg.mime.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to install files to support the 
        <link xlink:href="https://specifications.freedesktop.org/shared-mime-info-spec/shared-mime-info-spec-latest.html">XDG Shared MIME-info specification</link> and the
        <link xlink:href="https://specifications.freedesktop.org/mime-apps-spec/mime-apps-spec-latest.html">XDG MIME Applications specification</link>.
      '';
    };
  };

  config = mkIf config.xdg.mime.enable {
    environment.pathsToLink = [ "/share/mime" ];

    environment.systemPackages = [ 
      # this package also installs some useful data, as well as its utilities 
      pkgs.shared-mime-info 
    ];

    environment.extraSetup = ''
      if [ -w $out/share/mime ]; then
        XDG_DATA_DIRS=$out/share ${pkgs.shared-mime-info}/bin/update-mime-database -V $out/share/mime > /dev/null
      fi

      if [ -w $out/share/applications ]; then
        ${pkgs.desktop-file-utils}/bin/update-desktop-database $out/share/applications
      fi
    '';
  };

}
