{
  lib,
  pkgs,
  config,
  ...
}:

{

options.programs.gtk-nocsd = {
    enable = lib.mkEnableOption "gtk-nocsd system-wide.";
};

config = lib.mkIf config.programs.gtk-nocsd.enable {
environment.sessionVariables = {
    GTK_CSD = "0";
    LD_PRELOAD = "${gtk-nocsd}/lib/libgtk-nocsd.so.0";
  };
environment.systemPackages with pkgs = [ gtk-nocsd ];
};
meta.maintainers = with lib.maintainers; [ mr-banana-egg ];
}
