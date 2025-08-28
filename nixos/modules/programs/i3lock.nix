{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.programs.i3lock;

in
{

  ###### interface

  options = {
    programs.i3lock = {
      enable = lib.mkEnableOption "i3lock";
      package = lib.mkPackageOption pkgs "i3lock" {
        example = "i3lock-color";
        extraDescription = ''
          ::: {.note}
          The i3lock package must include a i3lock file or link in its out directory in order for the u2fSupport option to work correctly.
          :::
        '';
      };
      u2fSupport = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = ''
          Whether to enable U2F support in the i3lock program.
          U2F enables authentication using a hardware device, such as a security key.
          When U2F support is enabled, the i3lock program will set the setuid bit on the i3lock binary and enable the pam u2fAuth service,
        '';
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    security.wrappers.i3lock = lib.mkIf cfg.u2fSupport {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${cfg.package.out}/bin/i3lock";
    };

    security.pam.services.i3lock.u2fAuth = cfg.u2fSupport;

  };

}
