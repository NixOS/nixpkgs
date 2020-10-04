
# Management of static files in /opt.

{ config, lib, pkgs, ... }:

with lib;

let
  opt' = filter (f: f.enable) (attrValues config.environment.opt);

  opt = pkgs.stdenvNoCC.mkDerivation {
    name = "opt";

    builder = ./make-opt.sh;

    preferLocalBuild = true;
    allowSubstitutes = false;

    /* !!! Use toXML. */
    sources = map (x: x.source) opt';
    targets = map (x: x.target) opt';
    modes = map (x: x.mode) opt';
    users  = map (x: x.user) opt';
    groups  = map (x: x.group) opt';
  };

in

{

  ###### interface

  options = {

    environment.opt = mkOption {
      default = {};
      example = literalExample ''
        { example-configuration-file =
            { source = "/nix/store/.../opt/dir/file.conf.example";
              mode = "0440";
            };
          "default/useradd".text = "GROUP=100 ...";
        }
      '';
      description = ''
        Set of files that have to be linked in <filename>/opt</filename>.
      '';

      type = with types; attrsOf (submodule (
        { name, config, ... }:
        { options = {

            enable = mkOption {
              type = types.bool;
              default = true;
              description = ''
                Whether this /opt file should be generated.  This
                option allows specific /opt files to be disabled.
              '';
            };

            target = mkOption {
              type = types.str;
              description = ''
                Name of symlink (relative to
                <filename>/opt</filename>).  Defaults to the attribute
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
              let name' = "opt" + baseNameOf name;
              in mkDefault (pkgs.writeText name' config.text));
          };

        }));

    };
  };


  ###### implementation

  config = {

    system.activationScripts.opt = stringAfter [ "users" "groups" ]
      ''
        # Set up the statically computed bits of /opt.
        echo "setting up /opt..."
        mkdir -p /opt
        chmod 755 /opt
        ${pkgs.perl}/bin/perl -I${pkgs.perlPackages.FileSlurp}/${pkgs.perl.libPrefix} ${./setup-opt.pl} ${opt}/opt
      '';

  };

}
