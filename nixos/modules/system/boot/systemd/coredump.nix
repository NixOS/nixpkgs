{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.systemd.coredump;
  systemd = config.systemd.package;
in
{
  options = {
    systemd.coredump.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = ''
        Whether core dumps should be processed by
        {command}`systemd-coredump`. If disabled, core dumps
        appear in the current directory of the crashing process.
      '';
    };

    systemd.coredump.extraConfig = lib.mkOption {
      default = "";
      type = lib.types.lines;
      example = "Storage=journal";
      description = ''
        Extra config options for systemd-coredump. See coredump.conf(5) man page
        for available options.
      '';
    };
  };

  config = lib.mkMerge [

    (lib.mkIf cfg.enable {
      systemd.additionalUpstreamSystemUnits = [
        "systemd-coredump.socket"
        "systemd-coredump@.service"
      ];

      environment.etc = {
        "systemd/coredump.conf".text = ''
          [Coredump]
          ${cfg.extraConfig}
        '';

        # install provided sysctl snippets
        "sysctl.d/50-coredump.conf".source =
          # Fix systemd-coredump error caused by truncation of `kernel.core_pattern`
          # when the `systemd` derivation name is too long. This works by substituting
          # the path to `systemd` with a symlink that has a constant-length path.
          #
          # See: https://github.com/NixOS/nixpkgs/issues/213408
          pkgs.substitute {
            src = "${systemd}/example/sysctl.d/50-coredump.conf";
            substitutions = [
              "--replace-fail"
              "${systemd}"
              "${pkgs.symlinkJoin {
                name = "systemd";
                paths = [ systemd ];
              }}"
            ];
          };

        "sysctl.d/50-default.conf".source = "${systemd}/example/sysctl.d/50-default.conf";
      };

      users.users.systemd-coredump = {
        uid = config.ids.uids.systemd-coredump;
        group = "systemd-coredump";
      };
      users.groups.systemd-coredump = { };
    })

    (lib.mkIf (!cfg.enable) {
      boot.kernel.sysctl."kernel.core_pattern" = lib.mkDefault "core";
    })

  ];

}
