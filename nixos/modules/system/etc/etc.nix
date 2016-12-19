# Management of static files in /etc.

{ config, lib, pkgs, ... }:

with lib;

let

  etc' = filter (f: f.enable) (attrValues config.environment.etc);

  etc = pkgs.stdenvNoCC.mkDerivation {
    name = "etc";

    builder = ./make-etc.sh;

    preferLocalBuild = true;
    allowSubstitutes = false;

    /* !!! Use toXML. */
    sources = map (x: x.source) etc';
    targets = map (x: x.target) etc';
    modes = map (x: x.mode) etc';
    uids  = map (x: x.uid) etc';
    gids  = map (x: x.gid) etc';
  };

in

{

  ###### interface

  options = {

    environment.etc = mkOption {
      default = {};
      example = literalExample ''
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

      type = with types; loaOf (submodule (
        { name, config, ... }:
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

          };

          config = {
            target = mkDefault name;
            source = mkIf (config.text != null) (
              let name' = "etc-" + baseNameOf name;
              in mkDefault (pkgs.writeText name' config.text));
          };

        }));

    };

  };


  ###### implementation

  config = {

    system.build.etc = etc;

    system.activationScripts.etc = stringAfter [ "stdio" ]
      ''
        # Set up the statically computed bits of /etc.
        echo "setting up /etc..."
        ${pkgs.perl}/bin/perl -I${pkgs.perlPackages.FileSlurp}/lib/perl5/site_perl ${./setup-etc.pl} ${etc}/etc
      '';

  };

}
