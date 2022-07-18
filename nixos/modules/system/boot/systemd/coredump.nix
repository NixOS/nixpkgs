{ config, lib, pkgs, utils, ... }:

with lib;

let
  cfg = config.systemd.coredump;
  systemd = config.systemd.package;
in {
  options = {
    systemd.coredump.enable = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether core dumps should be processed by
        <command>systemd-coredump</command>. If disabled, core dumps
        appear in the current directory of the crashing process.
      '';
    };

    systemd.coredump.extraConfig = mkOption {
      default = "";
      type = types.lines;
      example = "Storage=journal";
      description = ''
        Extra config options for systemd-coredump. See coredump.conf(5) man page
        for available options.
      '';
    };
  };

  config = {
    systemd.additionalUpstreamSystemUnits = [
      "systemd-coredump.socket"
      "systemd-coredump@.service"
    ];

    environment.etc = {
      "systemd/coredump.conf".text =
      ''
        [Coredump]
        ${cfg.extraConfig}
      '';

      # install provided sysctl snippets
      "sysctl.d/50-coredump.conf".source = "${systemd}/example/sysctl.d/50-coredump.conf";
      "sysctl.d/50-default.conf".source = "${systemd}/example/sysctl.d/50-default.conf";
    };

    users.users.systemd-coredump = {
      uid = config.ids.uids.systemd-coredump;
      group = "systemd-coredump";
    };
    users.groups.systemd-coredump = {};

    boot.kernel.sysctl."kernel.core_pattern" = mkIf (!cfg.enable) "core";
  };
}
