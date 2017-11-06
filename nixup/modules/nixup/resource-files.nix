{ config, lib, pkgs, ... }:

with lib;

let
  managed' = filter (f: f.enable) (attrValues config.user.files);

  managed = pkgs.stdenvNoCC.mkDerivation {
    name = "managed";

    builder = ./make-managed.sh;

    preferLocalBuild = true;
    allowSubstitutes = false;

    /* !!! Use toXML. */
    targets = map (x: x.target) managed';
    sources = map (x: x.source) managed';
    dynamics = map (x: x.dynamic) managed';
    volatiles = map (x: x.volatile) managed';
    modes = map (x: x.mode) managed';
    users  = map (x: x.user) managed';
    groups  = map (x: x.group) managed';
  };
in

{
  options = {
    user.files = mkOption rec {
      default = {};
      type = types.loaOf (types.submodule options);
      example = literalExample ''
        [ { target = ".ssh/config";
            content = "
              Host home.my-domain.name
              User seti
            ";
          }
          { target = ".gitconfig";
            source = ./gitconfig;
          }
        ]
      '';
      description = ''
        Set of files that have to be linked in the home directory.
      '';

      options = { name, config, ... }: {
        options = {
          enable = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Whether this <filename>~/.</filename> file should be generated.  This
              option allows specific <filename>~/.</filename> files to be disabled.
            '';
          };

          target = mkOption {
            type = types.relativePath;
            description = ''
              Name of symlink (relative to <filename>~/.</filename>).
              Defaults to the attribute name.
            '';
          };

          dynamic = mkOption {
            type = types.bool;
            default = false;
            description = ''
              WARNING: USE WITH CARE!!

              Execute the file instead of linking or copying it.

              The file is expected to be an executable that receives the "target" filename
              as its only input parameter and then generates the "target" file dynamically.
              So it is possible for the executable to alter its behaviour depending on the
              current "target" file and e.g. initialize, upgrade or reset an existing file.
              The executable is re-executed with every run of the top-level activation script
              and is expected to behave as idempotent as sensible.
            '';
          };

          volatile = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Expect the content of the file to change after being generated.
              That option disables warnings if the managed file is modified directly.
            '';
          };

          content = mkOption {
            default = null;
            type = types.nullOr types.lines;
            description = "Content of the file.";
          };

          source = mkOption {
            type = types.path;
            description = "Path of the source file.";
          };

          mode = mkOption {
            type = types.str;
            default = "symlink";
            example = "0600";
            description = ''
              If set to something else than <literal>symlink</literal>,
              the file is copied instead of symlinked, with the given
              file mode.
            '';
          };

          uid = mkOption {
            default = 0;
            type = types.int;
            description = ''
              UID of created file. Only takes affect when the file is
              copied (that is, the mode is not 'symlink').
              '';
          };

          gid = mkOption {
            default = 0;
            type = types.int;
            description = ''
              GID of created file. Only takes affect when the file is
              copied (that is, the mode is not 'symlink').
            '';
          };

          user = mkOption {
            default = "+${toString config.uid}";
            type = types.str;
            description = ''
              User name of created file.
              Only takes affect when the file is copied (that is, the mode is not 'symlink').
              Changing this option takes precedence over <literal>uid</literal>.
            '';
          };

          group = mkOption {
            default = "+${toString config.gid}";
            type = types.str;
            description = ''
              Group name of created file.
              Only takes affect when the file is copied (that is, the mode is not 'symlink').
              Changing this option takes precedence over <literal>gid</literal>.
            '';
          };

        };

        config = {
          target = mkDefault name;
          source = mkIf (config.content != null)
            (mkDefault (pkgs.writeText "managed-${name}" config.content));
        };
      };

    };
  };

  config = {
    nixup.buildCommands = ''
      mkdir -p $out
      ln -s ${managed} $out/resources

      ##
      ## create resource linking/unlinking/switching commands
      ## NOTE: The commands link directly to the derivation of the profile, and not to $NIXUP_RUNTIME_DIR/active-profile!
      ##
      mkdir -p $out/bin

      echo "#! ${pkgs.stdenv.shell}" > $out/bin/nixup-resources-link
      echo "/run/wrappers/bin/resource-manager link \$HOME ${managed}" >> $out/bin/nixup-resources-link
      chmod +x $out/bin/nixup-resources-link

      echo "#! ${pkgs.stdenv.shell}" > $out/bin/nixup-resources-unlink
      echo "/run/wrappers/bin/resource-manager unlink \$HOME ${managed}" >> $out/bin/nixup-resources-unlink
      chmod +x $out/bin/nixup-resources-unlink

      echo "#! ${pkgs.stdenv.shell}" > $out/bin/nixup-resources-cleanup
      echo "/run/wrappers/bin/resource-manager cleanup \$HOME" >> $out/bin/nixup-resources-cleanup
      chmod +x $out/bin/nixup-resources-cleanup
    '';

    nixup.activationScripts.resourceFiles = ''
      echo "Setting up resource files ..."
      if [ -L "$NIXUP_USER_GCROOTS_DIR/old-active-profile" ];
      then
          /run/wrappers/bin/resource-manager switch $HOME `${pkgs.coreutils}/bin/readlink $NIXUP_USER_GCROOTS_DIR/old-active-profile/resources` ${managed}
      else
          #TODO: implement "cleanup"# /run/wrappers/bin/resource-manager cleanup $HOME ${managed}
          /run/wrappers/bin/resource-manager link $HOME ${managed}
      fi
    '';
  };
}
