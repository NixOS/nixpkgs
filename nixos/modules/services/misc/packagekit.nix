{ config, lib, pkgs, ... }:

let
  cfg = config.services.packagekit;

  inherit (lib)
    mkEnableOption mkOption mkIf mkRemovedOptionModule types
    listToAttrs recursiveUpdate;

  iniFmt = pkgs.formats.ini { };

  confFiles = [
    (iniFmt.generate "PackageKit.conf" (recursiveUpdate
      {
        Daemon = {
          DefaultBackend = "test_nop";
          KeepCache = false;
        };
      }
      cfg.settings))

    (iniFmt.generate "Vendor.conf" (recursiveUpdate
      {
        PackagesNotFound = rec {
          DefaultUrl = "https://github.com/NixOS/nixpkgs";
          CodecUrl = DefaultUrl;
          HardwareUrl = DefaultUrl;
          FontUrl = DefaultUrl;
          MimeUrl = DefaultUrl;
        };
      }
      cfg.vendorSettings))
  ];

in
{
  imports = [
    (mkRemovedOptionModule [ "services" "packagekit" "backend" ] "Always set to test_nop, Nix backend is broken see #177946.")
  ];

  options.services.packagekit = {
    enable = mkEnableOption ''
      PackageKit, a cross-platform D-Bus abstraction layer for
      installing software. Software utilizing PackageKit can install
      software regardless of the package manager
    '';

    settings = mkOption {
      type = iniFmt.type;
      default = { };
      description = "Additional settings passed straight through to PackageKit.conf";
    };

    vendorSettings = mkOption {
      type = iniFmt.type;
      default = { };
      description = "Additional settings passed straight through to Vendor.conf";
    };
  };

  config = mkIf cfg.enable {

    services.dbus.packages = with pkgs; [ packagekit ];

    environment.systemPackages = with pkgs; [ packagekit ];

    systemd.packages = with pkgs; [ packagekit ];

    environment.etc = listToAttrs (map
      (e:
        lib.nameValuePair "PackageKit/${e.name}" { source = e; })
      confFiles);
  };
}
