{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  # added 2019-11-11
  imports = [
    (mkRemovedOptionModule [ "services" "xserver" "displayManager" "slim" ] ''
      The SLIM project is abandoned and their last release was in 2013.
      Because of this it poses a security risk to your system.
      Other issues include it not fully supporting systemd and logind sessions.
      Please use a different display manager such as LightDM, SDDM, or GDM.
      You can also use the startx module which uses Xinitrc.
    '')
  ];
}
