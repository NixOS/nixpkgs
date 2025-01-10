{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.xdg.mime;
  associationOptions = with types; attrsOf (
    coercedTo (either (listOf str) str) (x: concatStringsSep ";" (toList x)) str
  );
in

{
  meta = {
    maintainers = teams.freedesktop.members ++ (with maintainers; [ figsoda ]);
  };

  options = {
    xdg.mime.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to install files to support the
        [XDG Shared MIME-info specification](https://specifications.freedesktop.org/shared-mime-info-spec/shared-mime-info-spec-latest.html) and the
        [XDG MIME Applications specification](https://specifications.freedesktop.org/mime-apps-spec/mime-apps-spec-latest.html).
      '';
    };

    xdg.mime.addedAssociations = mkOption {
      type = associationOptions;
      default = {};
      example = {
        "application/pdf" = "firefox.desktop";
        "text/xml" = [ "nvim.desktop" "codium.desktop" ];
      };
      description = ''
        Adds associations between mimetypes and applications. See the
        [
        specifications](https://specifications.freedesktop.org/mime-apps-spec/mime-apps-spec-latest.html#associations) for more information.
      '';
    };

    xdg.mime.defaultApplications = mkOption {
      type = associationOptions;
      default = {};
      example = {
        "application/pdf" = "firefox.desktop";
        "image/png" = [ "sxiv.desktop" "gimp.desktop" ];
      };
      description = ''
        Sets the default applications for given mimetypes. See the
        [
        specifications](https://specifications.freedesktop.org/mime-apps-spec/mime-apps-spec-latest.html#default) for more information.
      '';
    };

    xdg.mime.removedAssociations = mkOption {
      type = associationOptions;
      default = {};
      example = {
        "audio/mp3" = [ "mpv.desktop" "umpv.desktop" ];
        "inode/directory" = "codium.desktop";
      };
      description = ''
        Removes associations between mimetypes and applications. See the
        [
        specifications](https://specifications.freedesktop.org/mime-apps-spec/mime-apps-spec-latest.html#associations) for more information.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.etc."xdg/mimeapps.list" = mkIf (
      cfg.addedAssociations != {}
      || cfg.defaultApplications != {}
      || cfg.removedAssociations != {}
    ) {
      text = generators.toINI { } {
        "Added Associations" = cfg.addedAssociations;
        "Default Applications" = cfg.defaultApplications;
        "Removed Associations" = cfg.removedAssociations;
      };
    };

    environment.pathsToLink = [ "/share/mime" ];

    environment.systemPackages = [
      # this package also installs some useful data, as well as its utilities
      pkgs.shared-mime-info
    ];

    environment.extraSetup = ''
      if [ -w $out/share/mime ] && [ -d $out/share/mime/packages ]; then
          XDG_DATA_DIRS=$out/share PKGSYSTEM_ENABLE_FSYNC=0 ${pkgs.buildPackages.shared-mime-info}/bin/update-mime-database -V $out/share/mime > /dev/null
      fi

      if [ -w $out/share/applications ]; then
          ${pkgs.buildPackages.desktop-file-utils}/bin/update-desktop-database $out/share/applications
      fi
    '';
  };

}
