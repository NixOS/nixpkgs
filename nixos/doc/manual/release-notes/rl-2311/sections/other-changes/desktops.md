- GNOME, Pantheon, Cinnamon module no longer forces Qt applications to use Adwaita style since it was buggy and is no longer maintained upstream (specifically, Cinnamon now defaults to the gtk2 style instead, following the default in Linux Mint). If you still want it, you can add the following options to your configuration but it will probably be eventually removed:

  ```nix
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita";
  };
  ```
