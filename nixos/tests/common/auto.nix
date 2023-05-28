{ config, lib, ... }:

let
  dmcfg = config.services.xserver.displayManager;
  cfg = config.test-support.displayManager.auto;
in
{

  ###### interface

  options = {
    test-support.displayManager.auto = {
      enable = lib.mkOption {
        default = false;
        description = lib.mdDoc ''
          Whether to enable the fake "auto" display manager, which
          automatically logs in the user specified in the
          {option}`user` option.  This is mostly useful for
          automated tests.
        '';
      };

      user = lib.mkOption {
        default = "root";
        description = lib.mdDoc "The user account to login automatically.";
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
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
  };
}
