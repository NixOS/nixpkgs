{ config, lib, ... }:

<<<<<<< HEAD
let
  dmcfg = config.services.xserver.displayManager;
  cfg = config.test-support.displayManager.auto;
in
=======
with lib;

let

  dmcfg = config.services.xserver.displayManager;
  cfg = config.test-support.displayManager.auto;

in

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
{

  ###### interface

  options = {
<<<<<<< HEAD
    test-support.displayManager.auto = {
      enable = lib.mkOption {
=======

    test-support.displayManager.auto = {

      enable = mkOption {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        default = false;
        description = lib.mdDoc ''
          Whether to enable the fake "auto" display manager, which
          automatically logs in the user specified in the
          {option}`user` option.  This is mostly useful for
          automated tests.
        '';
      };

<<<<<<< HEAD
      user = lib.mkOption {
        default = "root";
        description = lib.mdDoc "The user account to login automatically.";
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
=======
      user = mkOption {
        default = "root";
        description = lib.mdDoc "The user account to login automatically.";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    services.xserver.displayManager = {
      lightdm.enable = true;
      autoLogin = {
        enable = true;
        user = cfg.user;
      };
    };

    # lightdm by default doesn't allow auto login for root, which is
    # required by some nixos tests. Override it here.
    security.pam.services.lightdm-autologin.text = lib.mkForce ''
        auth     requisite pam_nologin.so
        auth     required  pam_succeed_if.so quiet
        auth     required  pam_permit.so

        account  include   lightdm

        password include   lightdm

        session  include   lightdm
    '';
<<<<<<< HEAD
  };
=======

  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
