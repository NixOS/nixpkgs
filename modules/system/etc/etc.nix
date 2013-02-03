# Management of static files in /etc.

{ config, pkgs, ... }:

with pkgs.lib;

let

  etc = pkgs.stdenv.mkDerivation {
    name = "etc";

    builder = ./make-etc.sh;

    preferLocalBuild = true;

    /* !!! Use toXML. */
    sources = map (x: x.source) config.environment.etc;
    targets = map (x: x.target) config.environment.etc;
    modes = map (x: x.mode) config.environment.etc;
  };

in

{

  ###### interface

  options = {

    environment.etc = mkOption {
      default = [];
      example = [
        { source = "/nix/store/.../etc/dir/file.conf.example";
          target = "dir/file.conf";
          mode = "0440";
        }
      ];
      description = ''
        List of files that have to be linked in <filename>/etc</filename>.
      '';
      type = types.listOf types.optionSet;
      options = {
        source = mkOption {
          description = "Source file.";
        };
        target = mkOption {
          description = "Name of symlink (relative to <filename>/etc</filename>).";
        };
        mode = mkOption {
          default = "symlink";
          example = "0600";
          description = ''
            If set to something else than <literal>symlink</literal>,
            the file is copied instead of symlinked, with the given
            file mode.
          '';
        };
      };
    };

  };


  ###### implementation

  config = {

    system.build.etc = etc;

    system.activationScripts.etc = stringAfter [ "stdio" ]
      ''
        # Set up the statically computed bits of /etc.
        echo "setting up /etc..."
        ${pkgs.perl}/bin/perl ${./setup-etc.pl} ${etc}/etc
      '';

  };

}
