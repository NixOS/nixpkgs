{ config, pkgs, lib, ... }:
let
  inherit (lib) mkOption types mkIf optionalString;

  cfg = config.services.kmscon;

  configDir = pkgs.writeTextFile { name = "kmscon-config"; destination = "/kmscon.conf"; text = cfg.extraConfig; };
in {
  options = {
    services.kmscon = {
      enable = mkOption {
        description = ''
          Use kmscon as the virtual console instead of gettys.
          kmscon is a kms/dri-based userspace virtual terminal implementation.
          It supports a richer feature set than the standard linux console VT,
          including full unicode support, and when the video card supports drm
          should be much faster.
        '';
        type = types.bool;
        default = false;
      };

      hwRender = mkOption {
        description = "Whether to use 3D hardware acceleration to render the console.";
        type = types.bool;
        default = false;
      };

      extraConfig = mkOption {
        description = "Extra contents of the kmscon.conf file.";
        type = types.lines;
        default = "";
        example = "font-size=14";
      };
    };
  };

  config = mkIf cfg.enable {
    # Largely copied from unit provided with kmscon source
    systemd.units."kmsconvt@.service".text = ''
      [Unit]
      Description=KMS System Console on %I
      Documentation=man:kmscon(1)
      After=systemd-user-sessions.service
      After=plymouth-quit-wait.service
      After=systemd-logind.service
      After=systemd-vconsole-setup.service
      Requires=systemd-logind.service
      Before=getty.target
      Conflicts=getty@%i.service
      OnFailure=getty@%i.service
      IgnoreOnIsolate=yes
      ConditionPathExists=/dev/tty0

      [Service]
      ExecStart=${pkgs.kmscon}/bin/kmscon "--vt=%I" --seats=seat0 --no-switchvt --configdir ${configDir} --login -- ${pkgs.shadow}/bin/login -p
      UtmpIdentifier=%I
      TTYPath=/dev/%I
      TTYReset=yes
      TTYVHangup=yes
      TTYVTDisallocate=yes

      X-RestartIfChanged=false
    '';

    systemd.units."autovt@.service".unit = pkgs.runCommand "unit" { }
        ''
          mkdir -p $out
          ln -s ${config.systemd.units."kmsconvt@.service".unit}/kmsconvt@.service $out/autovt@.service
        '';

    systemd.services.systemd-vconsole-setup.restartIfChanged = false;

    services.kmscon.extraConfig = mkIf cfg.hwRender ''
      drm
      hwaccel
    '';

    hardware.opengl.enable = mkIf cfg.hwRender true;
  };
}
