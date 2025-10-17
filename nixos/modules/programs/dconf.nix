{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.dconf;

  # Compile keyfiles to dconf DB
  compileDconfDb =
    dir:
    pkgs.runCommand "dconf-db" {
      nativeBuildInputs = [ (lib.getBin pkgs.dconf) ];
    } "dconf compile $out ${dir}";

  # Check if dconf keyfiles are valid
  checkDconfKeyfiles =
    dir:
    pkgs.runCommand "check-dconf-keyfiles"
      {
        nativeBuildInputs = [ (lib.getBin pkgs.dconf) ];
      }
      ''
        if [[ -f ${dir} ]]; then
          echo "dconf keyfiles should be a directory but a file is provided: ${dir}"
          exit 1
        fi

        dconf compile db ${dir} || (
          echo "The dconf keyfiles are invalid: ${dir}"
          exit 1
        )
        cp -R ${dir} $out
      '';

  mkAllLocks =
    settings:
    lib.flatten (lib.mapAttrsToList (k: v: lib.mapAttrsToList (k': _: "/${k}/${k'}") v) settings);

  # Generate dconf DB from dconfDatabase and keyfiles
  mkDconfDb =
    val:
    compileDconfDb (
      pkgs.symlinkJoin {
        name = "nixos-generated-dconf-keyfiles";
        paths = [
          (pkgs.writeTextDir "nixos-generated-dconf-keyfiles" (lib.generators.toDconfINI val.settings))
          (pkgs.writeTextDir "locks/nixos-generated-dconf-locks" (
            lib.concatStringsSep "\n" (if val.lockAll then mkAllLocks val.settings else val.locks)
          ))
        ]
        ++ (map checkDconfKeyfiles val.keyfiles);
      }
    );

  # Check if a dconf DB file is valid. The dconf cli doesn't return 1 when it can't
  # open the database file so we have to check if the output is empty.
  checkDconfDb =
    file:
    pkgs.runCommand "check-dconf-db"
      {
        nativeBuildInputs = [ (lib.getBin pkgs.dconf) ];
      }
      ''
        if [[ -d ${file} ]]; then
          echo "dconf DB should be a file but a directory is provided: ${file}"
          exit 1
        fi

        echo "file-db:${file}" > profile
        DCONF_PROFILE=$(pwd)/profile dconf dump / > output 2> error
        if [[ ! -s output ]] && [[ -s error ]]; then
          cat error
          echo "The dconf DB file is invalid: ${file}"
          exit 1
        fi

        cp ${file} $out
      '';

  # Generate dconf profile
  mkDconfProfile =
    name: value:
    if lib.isDerivation value || lib.isPath value then
      pkgs.runCommand "dconf-profile" { } ''
        if [[ -d ${value} ]]; then
          echo "Dconf profile should be a file but a directory is provided."
          exit 1
        fi
        mkdir -p $out/etc/dconf/profile/
        cp ${value} $out/etc/dconf/profile/${name}
      ''
    else
      pkgs.writeTextDir "etc/dconf/profile/${name}" (
        lib.concatMapStrings (x: "${x}\n") (
          (lib.optional value.enableUserDb "user-db:user")
          ++ (map (
            value:
            let
              db = if lib.isAttrs value && !lib.isDerivation value then mkDconfDb value else checkDconfDb value;
            in
            "file-db:${db}"
          ) value.databases)
        )
      );

  dconfDatabase =
    with lib.types;
    submodule {
      options = {
        keyfiles = lib.mkOption {
          type = listOf (oneOf [
            path
            package
          ]);
          default = [ ];
          description = "A list of dconf keyfile directories.";
        };
        settings = lib.mkOption {
          type = attrs;
          default = { };
          description = "An attrset used to generate dconf keyfile.";
          example = literalExpression ''
            with lib.gvariant;
            {
              "com/raggesilver/BlackBox" = {
                scrollback-lines = mkUint32 10000;
                theme-dark = "Tommorow Night";
              };
            }
          '';
        };
        locks = lib.mkOption {
          type = with lib.types; listOf str;
          default = [ ];
          description = ''
            A list of dconf keys to be lockdown. This doesn't take effect if `lockAll`
            is set.
          '';
          example = literalExpression ''
            [ "/org/gnome/desktop/background/picture-uri" ]
          '';
        };
        lockAll = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Lockdown all dconf keys in `settings`.";
        };
      };
    };

  dconfProfile =
    with lib.types;
    submodule {
      options = {
        enableUserDb = lib.mkOption {
          type = bool;
          default = true;
          description = "Add `user-db:user` at the beginning of the profile.";
        };

        databases = lib.mkOption {
          type =
            with lib.types;
            listOf (oneOf [
              path
              package
              dconfDatabase
            ]);
          default = [ ];
          description = ''
            List of data sources for the profile. An element can be an attrset,
            or the path of an already compiled database. Each element is converted
            to a file-db.

            A key is searched from up to down and the first result takes the
            priority. If a lock for a particular key is installed then the value from
            the last database in the profile where the key is locked will be used.
            This can be used to enforce mandatory settings.
          '';
        };
      };
    };

in
{
  options = {
    programs.dconf = {
      enable = lib.mkEnableOption "dconf";

      profiles = lib.mkOption {
        type =
          with lib.types;
          attrsOf (oneOf [
            path
            package
            dconfProfile
          ]);
        default = { };
        description = ''
          Attrset of dconf profiles. By default the `user` profile is used which
          ends up in `/etc/dconf/profile/user`.
        '';
        example = lib.literalExpression ''
          {
            # A "user" profile with a database
            user.databases = [
              {
                settings = { };
              }
            ];
            # A "bar" profile from a package
            bar = pkgs.bar-dconf-profile;
            # A "foo" profile from a path
            foo = ''${./foo}
          };
        '';
      };

      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = "A list of packages which provide dconf profiles and databases in {file}`/etc/dconf`.";
      };
    };
  };

  config = lib.mkIf (cfg.profiles != { } || cfg.enable) {
    programs.dconf.packages = lib.mapAttrsToList mkDconfProfile cfg.profiles;

    environment.etc.dconf = lib.mkIf (cfg.packages != [ ]) {
      source = pkgs.symlinkJoin {
        name = "dconf-system-config";
        paths = map (x: "${x}/etc/dconf") cfg.packages;
        nativeBuildInputs = [ (lib.getBin pkgs.dconf) ];
        postBuild = ''
          if test -d $out/db; then
            dconf update $out/db
          fi
        '';
      };
    };

    services.dbus.packages = [ pkgs.dconf ];

    systemd.packages = [ pkgs.dconf ];

    # For dconf executable
    environment.systemPackages = [ pkgs.dconf ];

    environment.sessionVariables = lib.mkIf cfg.enable {
      # Needed for unwrapped applications
      GIO_EXTRA_MODULES = [ "${pkgs.dconf.lib}/lib/gio/modules" ];
    };
  };
}
