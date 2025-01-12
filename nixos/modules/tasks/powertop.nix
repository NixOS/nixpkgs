{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.powerManagement.powertop;
in
{
  ###### interface

  options.powerManagement.powertop = {
    enable = mkEnableOption "powertop auto tuning on startup";

    preStart = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Shell commands executed before `powertop` is started.
      '';
    };

    postStart = mkOption {
      type = types.lines;
      default = "";
      example = ''
        ''${lib.getExe' config.systemd.package "udevadm"} trigger -c bind -s usb -a idVendor=046d -a idProduct=c08c
      '';
      description = ''
        Shell commands executed after `powertop` is started.

        This can be used to workaround problematic configurations. For example,
        you can retrigger an `udev` rule to disable power saving on unsupported
        USB devices:
        ```
        services.udev.extraRules = ''''
          # disable USB auto suspend for Logitech, Inc. G PRO Gaming Mouse
          ACTION=="bind", SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c08c", TEST=="power/control", ATTR{power/control}="on"
        '''';
        ```
      '';
    };
  };

  ###### implementation

  config = mkIf (cfg.enable) {
    systemd.services = {
      powertop = {
        wantedBy = [ "multi-user.target" ];
        after = [ "multi-user.target" ];
        description = "Powertop tunings";
        path = [ pkgs.kmod ];
        preStart = cfg.preStart;
        postStart = cfg.postStart;
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = "yes";
          ExecStart = "${pkgs.powertop}/bin/powertop --auto-tune";
        };
      };
    };
  };
}
