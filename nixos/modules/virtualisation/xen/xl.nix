# Xen Project Hypervisor Domain 0 libxenlight configuration
{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf mkOption attrByPath;

  cfg = config.virtualisation.xen;

  settingsFormat = pkgs.formats.xenLight { type = "conf"; };
in
{
  ## Interface ##

  options.virtualisation.xen = {
    settings = mkOption {
      inherit (settingsFormat) type;
      default = { };
      example = {
        autoballoon = "off";
        bootloader_restrict = false;
        lockfile = "/run/lock/xen/xl";
        max_grant_version = 256;
        "vif.default.bridge" = "xenbr0";
        "vm.hvm.cpumask" = [
          "2"
          "3-8,^5"
        ];
      };
      description = ''
        The contents of the `/etc/xen/xl.conf` file.
        See {manpage}`xl.conf(5)` for available configuration options.
      '';
    };
  };

  ## Implementation ##

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion =
          (cfg.dom0Resources.memory != 0) -> ((attrByPath [ "autoballoon" ] "auto" cfg.settings) != "on");
        message = ''
          Upstream Xen strongly recommends that autoballoon be set to "off" or "auto" if
          virtualisation.xen.dom0Resources.memory is limiting the total Domain 0 memory.
        '';
      }
    ];
    environment.etc."xen/xl.conf".source = settingsFormat.generate "xl.conf" cfg.settings;
  };
}
