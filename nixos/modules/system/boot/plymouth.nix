{ config, lib, pkgs, ... }:

with lib;

let

  inherit (pkgs) plymouth;
  inherit (pkgs) nixos-icons;

  cfg = config.boot.plymouth;

  nixosBreezePlymouth = pkgs.breeze-plymouth.override {
    logoFile = cfg.logo;
    logoName = "nixos";
    osName = "NixOS";
    osVersion = config.system.nixos.release;
  };

  themesEnv = pkgs.buildEnv {
    name = "plymouth-themes";
    paths = [ plymouth ] ++ cfg.themePackages;
  };

  configFile = pkgs.writeText "plymouthd.conf" ''
    [Daemon]
    ShowDelay=0
    Theme=${cfg.theme}
  '';

in

{

  options = {

    boot.plymouth = {

      enable = mkEnableOption "Plymouth boot splash screen";

      themePackages = mkOption {
        default = [ nixosBreezePlymouth ];
        type = types.listOf types.package;
        description = ''
          Extra theme packages for plymouth.
        '';
      };

      theme = mkOption {
        default = "breeze";
        type = types.str;
        description = ''
          Splash screen theme.
        '';
      };

      logo = mkOption {
        type = types.path;
        default = "${nixos-icons}/share/icons/hicolor/128x128/apps/nix-snowflake.png";
        defaultText = ''pkgs.fetchurl {
          url = "https://nixos.org/logo/nixos-hires.png";
          sha256 = "1ivzgd7iz0i06y36p8m5w48fd8pjqwxhdaavc0pxs7w1g7mcy5si";
        }'';
        description = ''
          Logo which is displayed on the splash screen.
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    boot.kernelParams = [ "splash" ];

    # To be discoverable by systemd.
    environment.systemPackages = [ plymouth ];

    environment.etc."plymouth/plymouthd.conf".source = configFile;
    environment.etc."plymouth/plymouthd.defaults".source = "${plymouth}/share/plymouth/plymouthd.defaults";
    environment.etc."plymouth/logo.png".source = cfg.logo;
    environment.etc."plymouth/themes".source = "${themesEnv}/share/plymouth/themes";
    # XXX: Needed because we supply a different set of plugins in initrd.
    environment.etc."plymouth/plugins".source = "${plymouth}/lib/plymouth";

    systemd.packages = [ plymouth ];

    systemd.services.plymouth-kexec.wantedBy = [ "kexec.target" ];
    systemd.services.plymouth-halt.wantedBy = [ "halt.target" ];
    systemd.services.plymouth-quit-wait.wantedBy = [ "multi-user.target" ];
    systemd.services.plymouth-quit = {
      wantedBy = [ "multi-user.target" ];
      after = [ "display-manager.service" ];
    };
    systemd.services.plymouth-poweroff.wantedBy = [ "poweroff.target" ];
    systemd.services.plymouth-reboot.wantedBy = [ "reboot.target" ];
    systemd.services.plymouth-read-write.wantedBy = [ "sysinit.target" ];

    boot.initrd.extraUtilsCommands = ''
      copy_bin_and_libs ${pkgs.plymouth}/bin/plymouthd
      copy_bin_and_libs ${pkgs.plymouth}/bin/plymouth

      moduleName="$(sed -n 's,ModuleName *= *,,p' ${themesEnv}/share/plymouth/themes/${cfg.theme}/${cfg.theme}.plymouth)"

      mkdir -p $out/lib/plymouth/renderers
      # module might come from a theme
      cp ${themesEnv}/lib/plymouth/{text,details,$moduleName}.so $out/lib/plymouth
      cp ${plymouth}/lib/plymouth/renderers/{drm,frame-buffer}.so $out/lib/plymouth/renderers

      mkdir -p $out/share/plymouth/themes
      cp ${plymouth}/share/plymouth/plymouthd.defaults $out/share/plymouth

      # copy themes into working directory for patching
      mkdir themes
      # use -L to copy the directories proper, not the symlinks to them
      cp -r -L ${themesEnv}/share/plymouth/themes/{text,details,${cfg.theme}} themes

      # patch out any attempted references to the theme or plymouth's themes directory
      chmod -R +w themes
      find themes -type f | while read file
      do
        sed -i "s,/nix/.*/share/plymouth/themes,$out/share/plymouth/themes,g" $file
      done

      cp -r themes/* $out/share/plymouth/themes
      cp ${cfg.logo} $out/share/plymouth/logo.png
    '';

    boot.initrd.extraUtilsCommandsTest = ''
      $out/bin/plymouthd --help >/dev/null
      $out/bin/plymouth --help >/dev/null
    '';

    boot.initrd.extraUdevRulesCommands = ''
      cp ${config.systemd.package}/lib/udev/rules.d/{70-uaccess,71-seat}.rules $out
      sed -i '/loginctl/d' $out/71-seat.rules
    '';

    # We use `mkAfter` to ensure that LUKS password prompt would be shown earlier than the splash screen.
    boot.initrd.preLVMCommands = mkAfter ''
      mkdir -p /etc/plymouth
      ln -s ${configFile} /etc/plymouth/plymouthd.conf
      ln -s $extraUtils/share/plymouth/plymouthd.defaults /etc/plymouth/plymouthd.defaults
      ln -s $extraUtils/share/plymouth/logo.png /etc/plymouth/logo.png
      ln -s $extraUtils/share/plymouth/themes /etc/plymouth/themes
      ln -s $extraUtils/lib/plymouth /etc/plymouth/plugins

      plymouthd --mode=boot --pid-file=/run/plymouth/pid --attach-to-session
      plymouth show-splash
    '';

    boot.initrd.postMountCommands = ''
      plymouth update-root-fs --new-root-dir="$targetRoot"
    '';

    # `mkBefore` to ensure that any custom prompts would be visible.
    boot.initrd.preFailCommands = mkBefore ''
      plymouth quit --wait
    '';

  };

}
