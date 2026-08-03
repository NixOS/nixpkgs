{ config, pkgs, lib, ... }:

{
  # GTK and cursor defaults.
  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Budgie";
    XDG_SESSION_DESKTOP = "budgie-desktop";
    GTK_THEME = "Qogir";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  environment.systemPackages = with pkgs; [
    qogir-theme
    qogir-icon-theme
    bibata-cursors
    dconf
    glib
  ];

  programs.dconf.enable = true;

  # Apply sensible defaults to the live user at login.
  systemd.user.services.euclid-budgie-defaults = {
    description = "Apply Euclid Budgie defaults";

    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      ${pkgs.dconf}/bin/dconf write \
        /org/gnome/desktop/interface/gtk-theme \
        "'Qogir'"

      ${pkgs.dconf}/bin/dconf write \
        /org/gnome/desktop/interface/icon-theme \
        "'Qogir'"

      ${pkgs.dconf}/bin/dconf write \
        /org/gnome/desktop/interface/cursor-theme \
        "'Bibata-Modern-Classic'"

      ${pkgs.dconf}/bin/dconf write \
        /org/gnome/desktop/interface/color-scheme \
        "'prefer-dark'"

      ${pkgs.dconf}/bin/dconf write \
        /org/gnome/desktop/interface/clock-show-weekday \
        true

      ${pkgs.dconf}/bin/dconf write \
        /org/gnome/desktop/wm/preferences/button-layout \
        "':minimize,maximize,close'"

      exit 0
    '';
  };
}
