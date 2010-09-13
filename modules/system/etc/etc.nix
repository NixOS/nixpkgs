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

  makeEtc = pkgs.stdenv.mkDerivation {
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

  system.build.etc = makeEtc;

  system.activationScripts.etc = stringAfter [ "systemConfig" "stdio" ]
    ''
      # Set up the statically computed bits of /etc.
      echo "setting up /etc..."
      staticEtc=/etc/static
      rm -f $staticEtc
      ln -s ${makeEtc}/etc $staticEtc
      for i in $(cd $staticEtc && find * -type l); do
          mkdir -p /etc/$(dirname $i)
          rm -f /etc/$i
          if test -e "$staticEtc/$i.mode"; then
              # Create a regular file in /etc.
              cp $staticEtc/$i /etc/$i
              chown 0.0 /etc/$i
              chmod "$(cat "$staticEtc/$i.mode")" /etc/$i
          else
              # Create a symlink in /etc.
              ln -s $staticEtc/$i /etc/$i
          fi
      done

      # Remove dangling symlinks that point to /etc/static.  These are
      # configuration files that existed in a previous configuration but not
      # in the current one.  For efficiency, don't look under /etc/nixos
      # (where all the NixOS sources live).
      for i in $(find /etc/ \( -path /etc/nixos -prune \) -o -type l); do
          target=$(readlink "$i")
          if test "''${target:0:''${#staticEtc}}" = "$staticEtc" -a ! -e "$i"; then
              rm -f "$i"
          fi
      done
    '';

}
