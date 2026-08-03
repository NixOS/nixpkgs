{ config, pkgs, lib, ... }: {
  programs.dconf.profiles.user.databases = [{
    settings = {
      "com/solus-project/budgie-panel" = {
        panels = [ "top-panel" "left-dock" ];
      };
      "com/solus-project/budgie-panel/panels/top-panel" = {
        position = "top";
        size = lib.gvariant.mkInt32 28;
        transparency = "dynamic";
        applets = [ "budgie-menu" "spacer" "notifications" "status" "clock" ];
      };
      "com/solus-project/budgie-panel/panels/left-dock" = {
        position = "left";
        size = lib.gvariant.mkInt32 48;
        transparency = "dynamic";
        autohide = "intelligent";
        applets = [ "icon-tasklist" ];
      };
      "com/solus-project/budgie-panel/applets/icon-tasklist" = {
        pinned-apps = [
          "firefox.desktop"
          "org.gnome.Nautilus.desktop"
          "gnome-terminal.desktop"
          "euclid-welcome.desktop"
          "budgie-desktop-settings.desktop"
          "ccsm.desktop"
        ];
      };
      "org/gnome/desktop/interface" = {
        gtk-theme = "Qogir";
        icon-theme = "Euclid-3D";
        cursor-theme = "Qogir";
        color-scheme = "prefer-light";
      };
      "org/gnome/desktop/wm/preferences" = {
        theme = "Emerald";
      };
    };
  }];

  environment.etc."compizconfig/Default.ini".text = ''
    [core]
    s0_active_plugins = core;ccp;move;resize;place;decoration;vpswitch;wall;expo;wobbly;3d;fade;scale;
    s0_outputs = 1920x1080+0+0;

    [decoration]
    s0_command = emerald --replace

    [cube]
    s0_color = #ffffff

    [wobbly]
    s0_friction = 3
  '';
}
