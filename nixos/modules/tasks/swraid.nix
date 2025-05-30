{
  config,
  pkgs,
  lib,
  ...
}:
let

  cfg = config.boot.swraid;

  mdadm_conf = config.environment.etc."mdadm.conf";

  enable_implicitly_for_old_state_versions = lib.versionOlder config.system.stateVersion "23.11";

  minimum_config_is_set =
    config_text: (builtins.match ".*(MAILADDR|PROGRAM).*" mdadm_conf.text) != null;

in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "boot" "initrd" "services" "swraid" "enable" ]
      [ "boot" "swraid" "enable" ]
    )
    (lib.mkRenamedOptionModule
      [ "boot" "initrd" "services" "swraid" "mdadmConf" ]
      [ "boot" "swraid" "mdadmConf" ]
    )
  ];

  options.boot.swraid = {
    enable = lib.mkEnableOption "swraid support using mdadm" // {
      description = ''
        Whether to enable support for Linux MD RAID arrays.

        When this is enabled, mdadm will be added to the system path,
        and MD RAID arrays will be detected and activated
        automatically, both in stage-1 (initramfs) and in stage-2 (the
        final NixOS system).

        This should be enabled if you want to be able to access and/or
        boot from MD RAID arrays. {command}`nixos-generate-config`
        should detect it correctly in the standard installation
        procedure.
      '';
      default = enable_implicitly_for_old_state_versions;
      defaultText = "`true` if stateVersion is older than 23.11";
    };

    mdadmConf = lib.mkOption {
      description = "Contents of {file}`/etc/mdadm.conf`.";
      type = lib.types.lines;
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    warnings =
      lib.mkIf (!enable_implicitly_for_old_state_versions && !minimum_config_is_set mdadm_conf)
        [
          "mdadm: Neither MAILADDR nor PROGRAM has been set. This will cause the `mdmon` service to crash."
        ];

    environment.systemPackages = [ pkgs.mdadm ];

    environment.etc."mdadm.conf".text = lib.mkAfter cfg.mdadmConf;

    services.udev.packages = [ pkgs.mdadm ];

    systemd.packages = [ pkgs.mdadm ];

    boot.initrd = {
      availableKernelModules = [
        "md_mod"
        "raid0"
        "raid1"
        "raid10"
        "raid456"
      ];

      extraUdevRulesCommands = lib.mkIf (!config.boot.initrd.systemd.enable) ''
        cp -v ${pkgs.mdadm}/lib/udev/rules.d/*.rules $out/
      '';

      extraUtilsCommands = lib.mkIf (!config.boot.initrd.systemd.enable) ''
        # Add RAID mdadm tool.
        copy_bin_and_libs ${pkgs.mdadm}/sbin/mdadm
        copy_bin_and_libs ${pkgs.mdadm}/sbin/mdmon
      '';

      extraUtilsCommandsTest = lib.mkIf (!config.boot.initrd.systemd.enable) ''
        $out/bin/mdadm --version
      '';

      extraFiles."/etc/mdadm.conf".source = pkgs.writeText "mdadm.conf" mdadm_conf.text;

      systemd = {
        contents."/etc/mdadm.conf".text = mdadm_conf.text;

        packages = [ pkgs.mdadm ];
        initrdBin = [ pkgs.mdadm ];
      };

      services.udev.packages = [ pkgs.mdadm ];
    };
  };
}
