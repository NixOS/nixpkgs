{ ... }:

{
  imports = [ ./graphical.nix ];

  users.users.demo =
    { isNormalUser = true;
      description = "Demo user account";
      extraGroups = [ "wheel" ];
      password = "demo";
      uid = 1000;
    };

  services.displayManager = {
    autoLogin = {
      enable = true;
      user = "demo";
    };
    sddm.autoLogin.relogin = true;
  };
}
