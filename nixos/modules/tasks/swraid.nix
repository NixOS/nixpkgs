{ config, pkgs, lib, ... }: let

  cfg = config.boot.swraid;

  mdadm_conf = config.environment.etc."mdadm.conf";

in {
  imports = [
    (lib.mkRenamedOptionModule [ "boot" "initrd" "services" "swraid" "enable" ] [ "boot" "swraid" "enable" ])
    (lib.mkRenamedOptionModule [ "boot" "initrd" "services" "swraid" "mdadmConf" ] [ "boot" "swraid" "mdadmConf" ])
  ];


  options.boot.swraid = {
    enable = lib.mkEnableOption (lib.mdDoc "swraid support using mdadm") // {
      description = lib.mdDoc ''
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
      default = lib.versionOlder config.system.stateVersion "23.11";
      defaultText = lib.mdDoc "`true` if stateVersion is older than 23.11";
    };

    mdadmConf = lib.mkOption {
      description = lib.mdDoc "Contents of {file}`/etc/mdadm.conf`.";
      type = lib.types.lines;
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    warnings = lib.mkIf
        ((builtins.match ".*(MAILADDR|PROGRAM).*" mdadm_conf.text) == null)
        [ "mdadm: Neither MAILADDR nor PROGRAM has been set. This will cause the `mdmon` service to crash." ];

    environment.systemPackages = [ pkgs.mdadm ];

    environment.etc."mdadm.conf".text = lib.mkAfter cfg.mdadmConf;

    services.udev.packages = [ pkgs.mdadm ];

    systemd.packages = [ pkgs.mdadm ];

    boot.initrd = {
      availableKernelModules = [ "md_mod" "raid0" "raid1" "raid10" "raid456" ];

      extraUdevRulesCommands = lib.mkIf (!config.boot.initrd.systemd.enable) ''
        cp -v ${pkgs.mdadm}/lib/udev/rules.d/*.rules $out/
      '';

      extraUtilsCommands = ''
        # Add RAID mdadm tool.
        copy_bin_and_libs ${pkgs.mdadm}/sbin/mdadm
        copy_bin_and_libs ${pkgs.mdadm}/sbin/mdmon
      '';

      extraUtilsCommandsTest = ''
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
