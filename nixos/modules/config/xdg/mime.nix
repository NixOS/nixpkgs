{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.xdg.mime;
  associationOptions =
    with lib.types;
    attrsOf (coercedTo (either (listOf str) str) (x: lib.concatStringsSep ";" (lib.toList x)) str);
in

{
  meta = {
    maintainers = lib.teams.freedesktop.members ++ (with lib.maintainers; [ figsoda ]);
  };

  options = {
    xdg.mime.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to install files to support the
        [XDG Shared MIME-info specification](https://specifications.freedesktop.org/shared-mime-info-spec/latest) and the
        [XDG MIME Applications specification](https://specifications.freedesktop.org/mime-apps-spec/latest).
      '';
    };

    xdg.mime.addedAssociations = lib.mkOption {
      type = associationOptions;
      default = { };
      example = {
        "application/pdf" = "firefox.desktop";
        "text/xml" = [
          "nvim.desktop"
          "codium.desktop"
        ];
      };
      description = ''
        Adds associations between mimetypes and applications. See the
        [
        specifications](https://specifications.freedesktop.org/mime-apps-spec/latest/associations) for more information.
      '';
    };

    xdg.mime.defaultApplications = lib.mkOption {
      type = associationOptions;
      default = { };
      example = {
        "application/pdf" = "firefox.desktop";
        "image/png" = [
          "sxiv.desktop"
          "gimp.desktop"
        ];
      };
      description = ''
        Sets the default applications for given mimetypes. See the
        [
        specifications](https://specifications.freedesktop.org/mime-apps-spec/latest/default) for more information.
      '';
    };

    xdg.mime.removedAssociations = lib.mkOption {
      type = associationOptions;
      default = { };
      example = {
        "audio/mp3" = [
          "mpv.desktop"
          "umpv.desktop"
        ];
        "inode/directory" = "codium.desktop";
      };
      description = ''
        Removes associations between mimetypes and applications. See the
        [
        specifications](https://specifications.freedesktop.org/mime-apps-spec/latest/associations) for more information.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."xdg/mimeapps.list" =
      lib.mkIf
        (cfg.addedAssociations != { } || cfg.defaultApplications != { } || cfg.removedAssociations != { })
        {
          text = lib.generators.toINI { } {
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
