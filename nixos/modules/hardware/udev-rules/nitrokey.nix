{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.hardware.nitrokey;

  nitrokey-rules = pkgs.stdenv.mkDerivation {
    name = "nitrokey-udev-rules-${pkgs.stdenv.lib.getVersion pkgs.nitrokey-app}";

    inherit (pkgs.nitrokey-app) src;

    dontBuild = true;

    patchPhase = ''
      substituteInPlace libnitrokey/data/41-nitrokey.rules --replace plugdev "${cfg.group}"
    '';

    installPhase = ''
      mkdir -p $out/etc/udev/rules.d
      cp libnitrokey/data/41-nitrokey.rules $out/etc/udev/rules.d
    '';

    meta = {
      description = "udev rules for Nitrokeys";
      inherit (pkgs.nitrokey-app.meta) homepage license maintainers;
    };
  };

in

{
  options.hardware.nitrokey = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enables udev rules for Nitrokey devices. By default grants access
        to users in the "nitrokey" group. You may want to install the
        nitrokey-app package, depending on your device and needs.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "nitrokey";
      example = "wheel";
      description = ''
        Grant access to Nitrokey devices to users in this group.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ nitrokey-rules ];
    users.groups.${cfg.group} = {};
  };
}
