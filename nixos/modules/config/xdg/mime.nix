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
    maintainers = lib.teams.freedesktop.members ++ [ ];
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
        "text/*" = [
          "nvim.desktop"
          "codium.desktop"
        ];
      };
      description = ''
        Adds associations between mimetypes and applications. See the
        [specifications](https://specifications.freedesktop.org/mime-apps-spec/latest/associations) for more information.
        Globs in all variations are supported.
      '';
    };

    xdg.mime.defaultApplications = lib.mkOption {
      type = associationOptions;
      default = { };
      example = {
        "application/pdf" = "firefox.desktop";
        "image/*" = [
          "sxiv.desktop"
          "gimp.desktop"
        ];
      };
      description = ''
        Sets the default applications for given mimetypes. See the
        [specifications](https://specifications.freedesktop.org/mime-apps-spec/latest/default) for more information.
        Globs in all variations are supported.
      '';
    };

    xdg.mime.removedAssociations = lib.mkOption {
      type = associationOptions;
      default = { };
      example = {
        "audio/*" = [
          "mpv.desktop"
          "umpv.desktop"
        ];
        "inode/directory" = "codium.desktop";
      };
      description = ''
        Removes associations between mimetypes and applications. See the
        [specifications](https://specifications.freedesktop.org/mime-apps-spec/latest/associations) for more information.
        Globs in all variations are supported.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."xdg/mimeapps.list" =
      let
        generateMimeScript =
          title: attrs:
          lib.optionalString (attrs != { }) ''
            echo "[${title}]" >> $out
          ''
          + (lib.concatStringsSep "\n" (
            lib.attrValues (
              lib.mapAttrs (
                k: v: ''generateMimeItem "${k}" "${if lib.isList v then lib.concatStringsSep ";" v else v}"''
              ) attrs
            )
          ));
      in
      lib.mkIf
        (cfg.addedAssociations != { } || cfg.defaultApplications != { } || cfg.removedAssociations != { })
        {
          source = pkgs.runCommandLocal "mimeapps.list" { } ''
            function generateMimeItem() {
              mime=$1
              app=$2
              if [[ $mime == *"*"* ]]; then
                while read line; do
                  if [[ $line == $mime ]]; then
                    echo "$line=$app" >> $out
                  fi
                done < ${pkgs.shared-mime-info}/share/mime/types
              else
                echo "$mime=$app" >> $out
              fi
            }
            ${lib.concatStringsSep "\n" (
              lib.attrValues (
                lib.mapAttrs generateMimeScript {
                  "Added Associations" = cfg.addedAssociations;
                  "Default Applications" = cfg.defaultApplications;
                  "Removed Associations" = cfg.removedAssociations;
                }
              )
            )}
          '';
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

          # Auto-set defaults for URL scheme handlers that have exactly one
          # registered handler. Some desktop environments (notably GNOME) need
          # an explicit default in mimeapps.list to resolve URL scheme handlers;
          # having the handler declared only in mimeinfo.cache is not sufficient.
          # Without this, browser-to-app authentication flows that rely on
          # custom URL schemes (e.g. OAuth redirects via slack://) fail.
          # See: https://github.com/NixOS/nixpkgs/issues/301893
          #
          # These defaults are installed at distribution-level priority
          # ($XDG_DATA_DIRS/applications/mimeapps.list) and are overridden by
          # entries in xdg.mime.defaultApplications (/etc/xdg/mimeapps.list)
          # and user-level configuration (~/.config/mimeapps.list).
          if [ -f $out/share/applications/mimeinfo.cache ]; then
              scheme_handler_defaults=""
              while IFS='=' read -r mime apps; do
                  handler_count=$(printf '%s' "$apps" | tr ';' '\n' | grep -c . || true)
                  if [ "$handler_count" -eq 1 ]; then
                      handler=$(printf '%s' "$apps" | sed 's/;*$//')
                      scheme_handler_defaults="''${scheme_handler_defaults}$mime=$handler"$'\n'
                  fi
              done < <(grep '^x-scheme-handler/' $out/share/applications/mimeinfo.cache || true)
              if [ -n "$scheme_handler_defaults" ]; then
                  printf '[Default Applications]\n%s' "$scheme_handler_defaults" > $out/share/applications/mimeapps.list
              fi
          fi
      fi
    '';
  };

}
