{
  services.xserver.desktopManager.session =
    [ { name = "none";
        supportExternalWM = true;
        genStart = wm: ''
          ${wm}
        '';
      }
    ];
}
