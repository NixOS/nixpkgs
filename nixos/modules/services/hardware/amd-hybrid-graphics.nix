{ config, pkgs, lib, ... }:

{

  ###### interface

  options = {

    hardware.amdHybridGraphics.disable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Completely disable the AMD graphics card and use the
        integrated graphics processor instead.
      '';
    };

  };


  ###### implementation

  config = lib.mkIf config.hardware.amdHybridGraphics.disable {
    systemd.services."amd-hybrid-graphics" = {
      path = [ pkgs.bash ];
      description = "Disable AMD Card";
      after = [ "sys-kernel-debug.mount" ];
      requires = [ "sys-kernel-debug.mount" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.bash}/bin/sh -c 'echo -e \"IGD\\nOFF\" > /sys/kernel/debug/vgaswitcheroo/switch; exit 0'";
        ExecStop = "${pkgs.bash}/bin/sh -c 'echo ON >/sys/kernel/debug/vgaswitcheroo/switch; exit 0'";
      };
    };
  };

}
