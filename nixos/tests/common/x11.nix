{ services.xserver.enable = true;

  # Automatically log in.
  services.xserver.displayManager.select = "auto";

  # Use IceWM as the window manager.
  services.xserver.windowManager.select = [ "icewm" ];

}
