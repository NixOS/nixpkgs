# GNOME Keyring daemon.

{ config, pkgs, lib, utils, ... }:

with lib;

{

  meta = {
    maintainers = teams.gnome.members;
  };

  ###### interface

  options = {

    services.gnome3.gnome-keyring = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable GNOME Keyring daemon, a service designed to
          take care of the user's security credentials,
          such as user names and passwords.
        '';
      };

    };

    security.pam =
      let
        name = "gnome-keyring";
        pamCfg = config.security.pam;
        modCfg = pamCfg.modules.${name};

        control = "optional";
        path = "${pkgs.gnome3.gnome-keyring}/lib/security/pam_gnome_keyring.so";
      in
      utils.pam.mkPamModule {
        inherit name;
        mkSvcConfigCondition = svcCfg: svcCfg.modules.${name}.enable;

        mkModuleOptions = global: {
          enable = mkOption {
            default = if global then false else modCfg.enable;
            type = types.bool;
            description = ''
              If enabled, pam_gnome_keyring will attempt to automatically unlock the
              user's default Gnome keyring upon login. If the user login password
              does not match their keyring password, Gnome Keyring will prompt
              separately after login.
            '';
          };
        };

        mkAuthConfig = svcCfg: {
          ${name} = {
            inherit control path;
            order = 25000;
          };
        };

        mkPasswordConfig = svcCfg: {
          ${name} = {
            inherit control path;
            args = [ "use_authtok" ];
            order = 10000;
          };
        };

        mkSessionConfig = svcCfg: {
          ${name} = {
            inherit control path;
            args = [ "auto_start" ];
            order = 17000;
          };
        };
      };

  };


  ###### implementation

  config = mkIf config.services.gnome3.gnome-keyring.enable {

    environment.systemPackages = [ pkgs.gnome3.gnome-keyring ];

    services.dbus.packages = [ pkgs.gnome3.gnome-keyring pkgs.gcr ];

    xdg.portal.extraPortals = [ pkgs.gnome3.gnome-keyring ];

    security.pam.services.login.modules.gnomeKeyring.enable = true;

    security.wrappers.gnome-keyring-daemon = {
      source = "${pkgs.gnome3.gnome-keyring}/bin/gnome-keyring-daemon";
      capabilities = "cap_ipc_lock=ep";
    };

  };

}
