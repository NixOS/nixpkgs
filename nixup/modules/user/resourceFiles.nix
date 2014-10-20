{ config, lib, ... }:

with lib;

let
  pkgs = config.nixpkgs.pkgs;
in

{
  options = {
    user.resourceFiles = mkOption rec {
      default = {};
      type = types.loaOf (types.submodule options);
      example = literalExample ''
        [ { target = ".ssh/config";
            text = "
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
            type = types.str;
            description = ''
              Name of symlink (relative to <filename>~/.</filename>).
              Defaults to the attribute name.
            '';
          };

          text = mkOption {
            default = null;
            type = types.nullOr types.lines;
            description = "Text of the file.";
          };

          source = mkOption {
            type = types.path;
            description = "Path of the source file.";
          };

          setupScript = mkOption {
            type = types.lines;
            internal = true;
            description = "Shell script code to produce the resource file.";
          };
        };

        config = {
          target = mkDefault name;
          source = mkIf (config.text != null)
            (mkDefault (config.pkgs.writeText "homeDir-${name}" config.text));

          setupScript = mkDefault ''
            target="$HOME/${config.target}"
            mkdir -p $(dirname $target)
            if test -e $target -a \! -L $target; then
              mv $target $target.backup
            fi
            ln -sf "${config.source}" $target
          '';
        };
      };

    };
  };

  config = {

    user.activationScripts.resourceFiles = ''
      echo "Setting up resource files ..."

      ${concatMapStringsSep "\n" (rc: rc.setupScript) (attrValues config.user.resourceFiles)}
    '';
  };
}
