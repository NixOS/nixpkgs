{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.packagekit;

  packagekitConf = ''
    [Daemon]
    DefaultBackend=${cfg.backend}
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

      # TODO: integrate with PolicyKit if the nix backend matures to the point
      # where it will require elevated permissions
      backend = mkOption {
        type = types.enum [ "test_nop" ];
        default = "test_nop";
        description = ''
          PackageKit supports multiple different backends and <literal>auto</literal> which
          should do the right thing.
          </para>
          <para>
          On NixOS however, we do not have a backend compatible with nix 2.0
          (refer to <link xlink:href="https://github.com/NixOS/nix/issues/233">this issue</link> so we have to force
          it to <literal>test_nop</literal> for now.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    services.dbus.packages = with pkgs; [ packagekit ];

    systemd.packages = with pkgs; [ packagekit ];

    environment.etc."PackageKit/PackageKit.conf".text = packagekitConf;
    environment.etc."PackageKit/Vendor.conf".text = vendorConf;
  };
}
