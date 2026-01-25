{
  lib,
  pkgs,
  config,
  ...
}:

{
  imports = [
    ../../../modules/profiles/minimal.nix
  ];

  config = lib.mkIf pkgs.stdenv.hostPlatform.isCygwin {
    boot = {
      bcache.enable = false;
      initrd = {
        supportedFilesystems = [ ];
      };
      kernel.sysctl = lib.mkForce { };
      loader.grub.enable = false;
      modprobeConfig.enable = false;
      supportedFilesystems = [ ];
    };

    console.enable = false;

    fonts.fontconfig.enable = false;

    # the default requires glibcLocales
    i18n.supportedLocales = [ ];

    networking = {
      dhcpcd.enable = false;
      firewall.enable = false;
      resolvconf.enable = false;
    };

    programs = {
      fuse.enable = false;
      less.enable = lib.mkForce false;
      nano.enable = false;
      ssh.systemd-ssh-proxy.enable = false;
    };

    security = {
      pam.enable = false;
      shadow.enable = false;
      sudo.enable = false;
    };

    services = {
      lvm.enable = false;
      udev.enable = false;
    };

    system = {
      disableInstallerTools = true;
      # this is needed because tasks/filesystems.nix unconditionally adds
      # dosfstools, and tasks/filesystems/ext adds e2fsprogs
      fsPackages = lib.mkForce [ ];
      # these match the cygwin defaults when "file" is prepended
      nssDatabases = {
        passwd = [ "db" ];
        group = [ "db" ];
      };
    };

    systemd = {
      enable = false;
      coredump.enable = false;
    };

    users = {
      users = lib.mkForce { };
      groups = lib.mkForce { };
    };

    environment.corePackages =
      with pkgs;
      lib.mkForce [
        bash
        coreutils
        openssh
        curl
        config.nix.package
      ];
    environment.defaultPackages = lib.mkForce [ ];

    nix = {
      settings.sandbox = false;
      package = pkgs.nixVersions.git;
    };
  };
}
