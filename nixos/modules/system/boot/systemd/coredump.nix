{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.systemd.coredump;
  systemd = config.systemd.package;
in
{
  imports = [
    (lib.mkRemovedOptionModule [
      "systemd"
      "coredump"
      "extraConfig"
    ] "Use systemd.coredump.settings.Coredump instead.")
  ];

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

    systemd.coredump.settings.Coredump = lib.mkOption {
      default = { };
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf utils.systemdUtils.unitOptions.unitOption;
      };
      example = {
        Storage = "journal";
      };
      description = ''
        Settings for systemd-coredump. See {manpage}`coredump.conf(5)` for
        available options.
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
        "systemd/coredump.conf".text = utils.systemdUtils.lib.settingsToSections cfg.settings;

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
