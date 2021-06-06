{ config, lib, pkgs, ... }:

{

  options.programs.clickshare-csc1.enable =
    lib.options.mkEnableOption ''
      Barco ClickShare CSC-1 driver/client.
      This allows users in the <literal>clickshare</literal>
      group to access and use a ClickShare USB dongle
      that is connected to the machine
    '';

  config = lib.modules.mkIf config.programs.clickshare-csc1.enable {
    environment.systemPackages = [ pkgs.clickshare-csc1 ];
    services.udev.packages = [ pkgs.clickshare-csc1 ];
    users.groups.clickshare = {};
  };

  meta.maintainers = [ lib.maintainers.yarny ];

}
