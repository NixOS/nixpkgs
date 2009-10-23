# produce a script to generate /etc
{config, pkgs, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption;

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

    inherit (pkgs) coreutils;

    /* !!! Use toXML. */
    sources = map (x: x.source) config.environment.etc;
    targets = map (x: x.target) config.environment.etc;
    modes = map (x: if x ? mode then x.mode else "symlink") config.environment.etc;
  };

in

{
  require = [option];

  system = {
    build = {
      etc = makeEtc;
    };

    activationScripts = {
      etc = pkgs.lib.fullDepEntry ''
        # Set up the statically computed bits of /etc.
        echo "setting up /etc..."
	/etc/kill-etc || true
	${makeEtc}/bin/fill-etc
	echo "/etc is set up"
      '' [
        "systemConfig"
        "defaultPath" # path to cp, chmod, chown
        "stdio"
      ];
    };
  };
}
