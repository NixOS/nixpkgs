{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.packagekit;

  backend = "nix";

  packagekitConf = ''
[Daemon]
DefaultBackend=${backend}
KeepCache=false
    '';

  vendorConf = ''
[PackagesNotFound]
DefaultUrl=https://github.com/NixOS/nixpkgs
CodecUrl=https://github.com/NixOS/nixpkgs
HardwareUrl=https://github.com/NixOS/nixpkgs
FontUrl=https://github.com/NixOS/nixpkgs
MimeUrl=https://github.com/NixOS/nixpkgs
      '';

in

{

  options = {

    services.packagekit = {
      enable = mkEnableOption
        ''
          PackageKit provides a cross-platform D-Bus abstraction layer for
          installing software. Software utilizing PackageKit can install
          software regardless of the package manager.
        '';
    };

  };

  config = mkIf cfg.enable {

    services.dbus.packages = [ pkgs.packagekit ];

    systemd.services.packagekit = {
      description = "PackageKit Daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${pkgs.packagekit}/libexec/packagekitd";
      serviceConfig.User = "root";
      serviceConfig.BusName = "org.freedesktop.PackageKit";
      serviceConfig.Type = "dbus";
    };

    environment.etc."PackageKit/PackageKit.conf".text = packagekitConf;
    environment.etc."PackageKit/Vendor.conf".text = vendorConf;

  };

}
