{ 
  # Automatically log in.
  services.xserver.displayManager.enable = "slim";
  services.xserver.displayManager.slim.autoLogin = true;
  services.xserver.displayManager.slim.defaultUser = "root";

  # Use IceWM as the window manager.
  services.xserver.windowManager.enable = [ "icewm" ];
}
