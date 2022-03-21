# Management of static files in /etc.

{ config, lib, pkgs, ... }:

with lib;

let

  etc' = filter (f: f.enable) (attrValues config.environment.etc);

  etc = pkgs.runCommandLocal "etc" {
    # This is needed for the systemd module
    passthru.targets = map (x: x.target) etc';
  } /* sh */ ''
    set -euo pipefail

    makeEtcEntry() {
      src="$1"
      target="$2"
      mode="$3"
      user="$4"
      group="$5"

      if [[ "$src" = *'*'* ]]; then
        # If the source name contains '*', perform globbing.
        mkdir -p "$out/etc/$target"
        for fn in $src; do
            ln -s "$fn" "$out/etc/$target/"
        done
      else

        mkdir -p "$out/etc/$(dirname "$target")"
        if ! [ -e "$out/etc/$target" ]; then
          ln -s "$src" "$out/etc/$target"
        else
          echo "duplicate entry $target -> $src"
          if [ "$(readlink "$out/etc/$target")" != "$src" ]; then
            echo "mismatched duplicate entry $(readlink "$out/etc/$target") <-> $src"
            ret=1

            continue
          fi
        fi

        if [ "$mode" != symlink ]; then
          echo "$mode" > "$out/etc/$target.mode"
          echo "$user" > "$out/etc/$target.uid"
          echo "$group" > "$out/etc/$target.gid"
        fi
      fi
    }

    mkdir -p "$out/etc"
    ${concatMapStringsSep "\n" (etcEntry: escapeShellArgs [
      "makeEtcEntry"
      # Force local source paths to be added to the store
      "${etcEntry.source}"
      etcEntry.target
      etcEntry.mode
      etcEntry.user
      etcEntry.group
    ]) etc'}
  '';

in

{

  imports = [ ../build.nix ];

  ###### interface

  options = {

    environment.etc = mkOption {
      default = {};
      example = literalExpression ''
        { example-configuration-file =
            { source = "/nix/store/.../etc/dir/file.conf.example";
              mode = "0440";
            };
          "default/useradd".text = "GROUP=100 ...";
        }
      '';
      description = ''
        Set of files that have to be linked in <filename>/etc</filename>.
      '';

      type = with types; attrsOf (submodule (
        { name, config, options, ... }:
        { options = {

            enable = mkOption {
              type = types.bool;
              default = true;
              description = ''
                Whether this /etc file should be generated.  This
                option allows specific /etc files to be disabled.
              '';
            };

            target = mkOption {
              type = types.str;
              description = ''
                Name of symlink (relative to
                <filename>/etc</filename>).  Defaults to the attribute
                name.
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
                UID of created file. Only takes effect when the file is
                copied (that is, the mode is not 'symlink').
                '';
            };

            gid = mkOption {
              default = 0;
              type = types.int;
              description = ''
                GID of created file. Only takes effect when the file is
                copied (that is, the mode is not 'symlink').
              '';
            };

            user = mkOption {
              default = "+${toString config.uid}";
              type = types.str;
              description = ''
                User name of created file.
                Only takes effect when the file is copied (that is, the mode is not 'symlink').
                Changing this option takes precedence over <literal>uid</literal>.
              '';
            };

            group = mkOption {
              default = "+${toString config.gid}";
              type = types.str;
              description = ''
                Group name of created file.
                Only takes effect when the file is copied (that is, the mode is not 'symlink').
                Changing this option takes precedence over <literal>gid</literal>.
              '';
            };

          };

          config = {
            target = mkDefault name;
            source = mkIf (config.text != null) (
              let name' = "etc-" + baseNameOf name;
              in mkDerivedConfig options.text (pkgs.writeText name')
            );
          };

        }));

    };

  };


  ###### implementation

  config = {

    system.build.etc = etc;
    system.build.etcActivationCommands =
      ''
        # Set up the statically computed bits of /etc.
        echo "setting up /etc..."
        ${pkgs.perl.withPackages (p: [ p.FileSlurp ])}/bin/perl ${./setup-etc.pl} ${etc}/etc
      '';
  };

}
