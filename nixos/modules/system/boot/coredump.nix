{ config, lib, pkgs, ... }:

with lib;

{

  options = {

    systemd.coredump = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enables storing core dumps in systemd.
          Note that this alone is not enough to enable core dumps. The maximum
          file size for core dumps must be specified in limits.conf as well. See
          <option>security.pam.loginLimits</option> as well as the limits.conf(5)
          man page.
        '';
      };

      extraConfig = mkOption {
        default = "";
        type = types.lines;
        example = "Storage=journal";
        description = ''
          Extra config options for systemd-coredump. See coredump.conf(5) man page
          for available options.
        '';
      };
    };

  };

  config = mkMerge [
    (mkIf config.systemd.coredump.enable {

      systemd.additionalUpstreamSystemUnits = [ "systemd-coredump.socket" "systemd-coredump@.service" ];

      environment.etc."systemd/coredump.conf".text =
        ''
          [Coredump]
          ${config.systemd.coredump.extraConfig}
        '';

      # Have the kernel pass core dumps to systemd's coredump helper binary.
      # From systemd's 50-coredump.conf file. See:
      # <https://github.com/systemd/systemd/blob/v218/sysctl.d/50-coredump.conf.in>
      boot.kernel.sysctl."kernel.core_pattern" = "|${pkgs.systemd}/lib/systemd/systemd-coredump %P %u %g %s %t %c %e";
    })

    (mkIf (!config.systemd.coredump.enable) {
      boot.kernel.sysctl."kernel.core_pattern" = mkDefault "core";

      systemd.extraConfig =
        ''
          DefaultLimitCORE=0:infinity
        '';
    })
  ];

}
