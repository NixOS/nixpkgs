{ config, pkgs, lib }:

let
  configuration = with lib; {
    imports = [
        (pkgs.path + "/nixos/modules/installer/netboot/netboot-minimal.nix")
    ];
    ## Some useful options for setting up a new system
    services.mingetty.autologinUser = mkForce "root";
    # Enable sshd which gets disabled by netboot-minimal.nix
    systemd.services.sshd.wantedBy = mkOverride 0 [ "multi-user.target" ];
    # users.users.root.openssh.authorizedKeys.keys = [ ... ];
    # i18n.consoleKeyMap = "de";
  };

  nixos = import (pkgs.path + "/nixos") {
    inherit configuration;
    # system = ...;
  };
in
  pkgs.symlinkJoin {
    name = "netboot";
    paths = with nixos.config.system.build; [
      netbootRamdisk
      kernel
      netbootIpxeScript
    ];
    preferLocalBuild = true;
  }
