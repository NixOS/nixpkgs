# Produce a script to generate /etc.
{ config, pkgs, ... }:

with pkgs.lib;

###### interface
let

  option = {
    environment.etc = mkOption {
      default = [];
      example = [
        { source = "/nix/store/.../etc/dir/file.conf.example";
          target = "dir/file.conf";
          mode = "0440";
        }
      ];
      description = ''
        List of files that have to be linked in /etc.
      '';
    };
  };
in

###### implementation
let

  copyScript = {source, target, mode ? "644", own ? "root.root"}:
    assert target != "nixos";
    ''
      source="${source}"
      target="/etc/${target}"
      mkdir -p $(dirname "$target")
      test -e "$target" && rm -f "$target"
      cp "$source" "$target"
      chown ${own} "$target"
      chmod ${mode} "$target"
    '';

  etc = pkgs.stdenv.mkDerivation {
    name = "etc";

    builder = ./make-etc.sh;

    /* !!! Use toXML. */
    sources = map (x: x.source) config.environment.etc;
    targets = map (x: x.target) config.environment.etc;
    modes = map (x: if x ? mode then x.mode else "symlink") config.environment.etc;
  };

in

{
  require = [option];

  system.build.etc = etc;

  system.activationScripts.etc = stringAfter [ "systemConfig" "stdio" ]
    ''
      # Set up the statically computed bits of /etc.
      echo "setting up /etc..."
      ${pkgs.perl}/bin/perl ${./setup-etc.pl} ${etc}/etc
    '';

}
