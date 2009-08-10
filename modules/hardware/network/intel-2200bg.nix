{pkgs, config, ...}:

{

  ###### interface

  options = {
  
    networking.enableIntel2200BGFirmware = pkgs.lib.mkOption {
      default = false;
      type = pkgs.lib.types.bool;
      description = ''
        Turn on this option if you want firmware for the Intel
        PRO/Wireless 2200BG to be loaded automatically.  This is
        required if you want to use this device.  Intel requires you to
        accept the license for this firmware, see
        <link xlink:href='http://ipw2200.sourceforge.net/firmware.php?fid=7'/>.
      '';
    };

  };


  ###### implementation
  
  config = pkgs.lib.mkIf config.networking.enableIntel2200BGFirmware {
  
    # Warning: setting this option requires acceptance of the firmware
    # license, see http://ipw2200.sourceforge.net/firmware.php?fid=7.
    hardware.firmware = [ pkgs.ipw2200fw ];

  };
  
}
