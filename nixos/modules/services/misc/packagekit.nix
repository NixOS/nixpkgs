{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.packagekit;

  packagekitConf = ''
    [Daemon]
    DefaultBackend=nix
    KeepCache=false
  '';

  vendorConf = let url = "https://github.com/NixOS/nixpkgs"; in ''
    [PackagesNotFound]
    DefaultUrl=${url}
    CodecUrl=${url}
    HardwareUrl=${url}
    FontUrl=${url}
    MimeUrl=${url}
  '';

in

{

  imports = [ (mkRemovedOptionModule [ "services" "packagekit" "backend" ] "Always set to Nix" ) ];

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

    services.dbus.packages = with pkgs; [ packagekit ];
    environment.systemPackages = with pkgs; [ packagekit ];
    systemd.packages = with pkgs; [ packagekit ];

    environment.etc."PackageKit/PackageKit.conf".text = packagekitConf;
    environment.etc."PackageKit/Vendor.conf".text = vendorConf;
  };
}
