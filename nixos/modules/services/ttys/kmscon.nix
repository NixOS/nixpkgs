{ config, pkgs, ... }:
let
  inherit (pkgs.lib) mkOption types mkIf optionalString;

  cfg = config.services.kmscon;

  configDir = pkgs.writeTextFile { name = "kmscon-config"; destination = "/kmscon.conf"; text = cfg.extraConfig; };
in {
  options = {
    services.kmscon = {
      enable = mkOption {
        description = "Use kmscon as the virtual console instead of gettys";
        type = types.bool;
        default = false;
      };

      hwRender = mkOption {
        description = "Whether to use 3D hardware acceleration to render the console";
        type = types.bool;
        default = false;
      };

      extraConfig = mkOption {
        description = "Extra contents of the kmscon.conf file";
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
    '';

    systemd.units."autovt@.service".linkTarget = "${config.systemd.units."kmsconvt@.service".unit}/kmsconvt@.service";

    services.kmscon.extraConfig = mkIf cfg.hwRender ''
      drm
      hwaccel
    '';
  };
}
