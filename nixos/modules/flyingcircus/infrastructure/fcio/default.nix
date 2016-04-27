{ config, lib, pkgs, ... }:
# Configuration for running on Flying Circus owned and operated infrastructure
# (i.e. not on Vagrant but in DEV, RZOB, ...)

with lib;

let
  cfg = config.flyingcircus;

in
{
  imports = [
      <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
  ];

  systemd.services.qemu-guest-agent = {
    description = "The Qemu guest agent.";
    wantedBy = [ "basic.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.qemu}/bin/qemu-ga -m virtio-serial -p /dev/virtio-ports/org.qemu.guest_agent.0";
      Restart = "always";
      RestartSec = "5s";
    };
  };

  # XXX This is rather sad, but Qemu can't ignore the mount and then we can't
  # freeze the filesystem properly. :(
  # Would need qemu to help here and notice that this is the same device as
  # the root.
  nix.readOnlyStore = false;

  system.activationScripts.readOnlyStore =
    if config.nix.readOnlyStore then ''
      ${pkgs.utillinux}/bin/mount | grep "/nix/store" > /dev/null ||
        echo "Want to activate nix.readOnlyStore=true" > /reboot
    '' else ''
      ${pkgs.utillinux}/bin/mount | grep "/nix/store" > /dev/null &&
        echo "Want to activate nix.readOnlyStore=false" > /reboot || true
    '';

  boot.blacklistedKernelModules = [ "bochs_drm" ];
  boot.initrd.supportedFilesystems = [ "xfs" ];
  boot.kernelParams = [
    # Crash management
    "panic=1"
    # panic_on_fail is a NixOSism managed by stage-1-init.sh
    "boot.panic_on_fail"
    "systemd.crash_reboot=yes"

    # Output management
    "console=ttyS0"
    "systemd.journald.forward_to_console=yes"
    "nosetmode"
    ];

  # installs /dev/disk/device-by-alias/*
  services.udev.extraRules = ''
    # Select GRUB boot device
    SUBSYSTEM=="block", KERNEL=="[vs]da", SYMLINK+="disk/device-by-alias/root"
  '';

  # Changing this can be nasty: grub is reconfigured before any configuration
  # is activated. This means we currently have to make sure that device exists
  # when switching the configuration to it.
  # https://github.com/NixOS/nixpkgs/issues/12833
  boot.loader.grub.device = "/dev/disk/device-by-alias/root";
  boot.loader.grub.fsIdentifier = "provided";
  boot.loader.grub.gfxmodeBios = "text";
  boot.loader.grub.timeout = 3;
  boot.loader.grub.version = 2;
  boot.supportedFilesystems = [ "xfs" ];
  boot.vesa = false;
  boot.consoleLogLevel = 0;

  networking.hostName = if config.flyingcircus.enc ? name
    then config.flyingcircus.enc.name
    else "default";

  services.openssh.permitRootLogin = "without-password";
  services.journald.extraConfig = "SystemMaxUse=5%";

  fileSystems."/".device = "/dev/disk/by-label/root";
  fileSystems."/tmp".device = "/dev/disk/by-label/tmp";
  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  users.users.root = {
    initialHashedPassword = "*";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEA1MDJf/ixCnyuiyS9PAUKfO+aIBe1YfFPtkKjQNUatxEGdp6+JvuXDzoGiPPA+/ITJ/oEbu7DL0KwZ+ltYUzot4B9QZSdOiEq/tliVAZqf3+XKPdqnVteY4qIswDi5+IUcnv6OgvPKLM/0xuGOtJglm2U21xTfLjwRVJet1WhTsM= zagy@lrrr.whq.gocept.com"
      "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAxnzx7B1Khw688K3DReYnKpEOng+nerk4mFGXOhWz1hOvU6QfI0K3oyZj79wSyBo4V/FG1xxOIxphm58jARvPmdEhpDEZh/ekbQ5DN7/tq65tMJuHaRWE2E2zKBAqV2vhqkYvQ5lbANeOAu6ismvSu/fglcUi0aS1d1MsgWXQvNKv4p5ylHfp3Y+b4YPeQpsNvwcJEKI0Y9HYSpHYE+DMQjojSgpntcBsgaKDf5AbyCve2wHRW0e2SpejpYrKjYOoySXXMTElfoF915D6pVhmWJy7ZrrvZkiwT6JgYs5NlGrLoyG7NGhDOF4/HyrABelX2C5feN7geIt6TUU0TW4S0Q== abittner"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDSj4vk5i9UlqkQSq+u7+O9BcK6Ag918T36J4vy4K2zhYacu7t0TQBFqpao3ohMEYlbYsi0VEeQEKGbQ6mVJbGAi0UZJwhMdTQ0AptmjPJle3fxZHSzXzSOyssukygb5UNBqelvdM8B4c5qOuVz75fEhaPfzYs3w/qVKT4W2M+162xoZstNLI8WH13OKFoiMU3ubUb9tQD8icsWhF1N2gScV/Anb3QdSHw0V18EOXpEM/rfwRf+uK7Vs84c41eFKWKBERkRGdm5Z6mtaqQ7nqvHdkloTTbfsPUBFq/dgUlmVTLUE36mRBs9cmsFLVsKwPDRntHPXULnrl9U3y6uLDVf ctheune@mindy"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDSejGFORJ7hlFraV3caVir3rWlo/QcsWptWrukk2C7eaGu/8tXMKgPtBHYdk4DYRi7EcPROllnFVzyVTLS/2buzfIy7XDjn7bwHzlHoBHZ4TbC9auqW3j5oxTDA4s2byP6b46Dh93aEP9griFideU/J00jWeHb27yIWv+3VdstkWTiJwxubspNdDlbcPNHBGOE+HNiAnRWzwyj8D0X5y73MISC3pSSYnXJWz+fI8IRh5LSLYX6oybwGX3Wu+tlrQjyN1i0ONPLxo5/YDrS6IQygR21j+TgLXaX8q8msi04QYdvnOqk1ntbY4fU8411iqoSJgCIG18tOgWTTOcBGcZX directory@directory.fcio.net"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDVWJXGKYk5Vt5b2lT55TjpOYz2dLlB95j9MFFhQ+VnEFYm6ylnPN4Ta5EIvdsecCKfAmUidfKb3T9vHIA4YqK3wVCICwjQkjD2yMl7mY9xVZA55R38A07QmOC4CziqHVHoLWuTQJREyFfC/FAEGn5KV/vsaV08U8VnIJftwCnfRiAvWA4UaRkfKNUft9rv41E4ZTAuZsHxm2PT649ATemyjdRZcNS2yQr5LSp1TmCU8wNobiGg++qf2SpjvUw2TgutyI8BGC7LB+fqwK6Tk/ILRI2l1wz0Vr1EwbMspGuoD/PTgUbvdG7wZLEj60KCCMEu/I0iaRyAVUVTJL/c2C07 flanitz"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCz7v7YuSEuG4R8Lq6UL6xWB2ew5UMp8zdijRbX8uao9gvMNWbvhbfFE6O8/Pp27H8Hneeqe9nOh/AxeIP+YJU3AM74QWhvqgP/emHThvUzPc9pOILwrLCgTCf8gXzR5Rvsor4XIxNNZj5BKXo71GLbpKBVYWiBNW1Z5YG4pAbcAldWS1LK6zdj6cc94D2Y4S2CGNfafJNW0BG+E0rdTvpoJPfiLMP0b0J+M2SM7fJRUHUZgeYZux44NPP74NC5YcKF7ejoHqiUy4H09Be5ukNhIRuSjeM0dlmiUfAcKndcLA6EuomDZvXCACc7l6Ukn5tC1sSrw7l7VGK0DC65A459 ckauhaus@lionel"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCt1XO6oiCeXJj6e3Ry2IGE+HFrq8GQfAOwNaJOwyxH7gtfmQ22HeosFBVnzRgi6xrOtJhEbi0gfG26Evq6dNSXlxPrQ1bsFFiY0sErfPd/5oEbYrXnr++uNKd+JY87kZ1IVVIWSPOC0aaoX4HLvo9SYtWg6PVlXtZYD0o7IE+8OPa9JsFfaKWWPsYh2wDevw/GqwCHSnTSp7Tl8cwIot+zj9EjUI1WPB+1Vk4eIeQoxIG/XBNq43j9Qei5o+0HQIVEqjPq3RvdTKpDxghRLj8SLmOIAuE/HDovvKx2aOU3ccpwp/Iomupy6NeJpXdmkuCXT+1LVeZm2Exggnhlinu/ plumps@Maksims-MacBook-Pro.local"
    ];
  };

  systemd.ctrl-alt-del = "poweroff.target";
  systemd.extraConfig = ''
    RuntimeWatchdogSec=60
  '';

  systemd.timers.serial-console-liveness = {
    description = "Timer for Serial console liveness marker";
    requiredBy = [ "serial-getty@ttyS0.service" ];
    timerConfig = {
      Unit = "serial-console-liveness.service";
      OnBootSec = "10m";
      OnUnitActiveSec = "10m";
    };
  };

  systemd.services.serial-console-liveness = {
    description = "Serial console liveness marker";
    serviceConfig.Type = "oneshot";
    script = "echo \"$(date) -- SERIAL CONSOLE IS LIVE --\" > /dev/ttyS0";
  };

  # Configure time keeping;
  services.ntp.enable = false;
  services.chrony.enable = true;

  services.chrony.servers = config.flyingcircus.static.ntpservers.${config.flyingcircus.enc.parameters.location};

}
