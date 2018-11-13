{ config, lib, pkgs, ... }:

with lib;

let
 pkgs2storeContents = l : map (x: { object = x; symlink = "none"; }) l;

in {
  # Docker image config.
  imports = [
    ../installer/cd-dvd/channel.nix
    ./minimal.nix
    ./clone-config.nix
  ];

  # Create the tarball
  system.build.tarball = pkgs.callPackage ../../lib/make-system-tarball.nix {

    contents = [];

    extraArgs = "--owner=0";

    storeContents = [
      # Add init script to image
      { object = config.system.build.toplevel + "/init";
        # use /sbin/init instead of /init as it's the default location of lxc and systemd-nspawn
        symlink = "/sbin/init";
      }
      # Add /etc/os-release from nix store upfront, so that it is there prior first boot.
      # for docker, this is only informative and not required, but for lxc, which also
      # imports this code, it is required when started with systemd-nspawn.
      { object = config.environment.etc."os-release".source;
        symlink = "/etc/os-release";
      }
    ] ++ (pkgs2storeContents [ pkgs.stdenv ]);

    # Some container managers like lxc need these
    extraCommands = "mkdir -p proc sys dev";
  };

  boot.isContainer = true;
  # TODO: /sbin/init handling could probably done through this,
  # but this is not enough for /sbin/init to land in the image
  # boot.loader.initScript.enable = true;
  boot.postBootCommands =
    ''
      # After booting, register the contents of the Nix store in the Nix
      # database.
      if [ -f /nix-path-registration ]; then
        ${config.nix.package.out}/bin/nix-store --load-db < /nix-path-registration &&
        rm /nix-path-registration
      fi

      # nixos-rebuild also requires a "system" profile
      ${config.nix.package.out}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system
    '';

  # Install new init script
  system.activationScripts.installInitScript = ''
    ln -fs --relative $systemConfig/init /sbin/init
  '';
}
