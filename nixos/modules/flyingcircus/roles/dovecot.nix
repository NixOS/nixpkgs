{ config, lib, pkgs, ... }: with lib;
{

  options = {

    flyingcircus.roles.dovecot = {

      enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable the Flying Circus dovecot server role.";
      };

    };

  };

  config = mkIf config.flyingcircus.roles.dovecot.enable {

  jobs.fcio-stubs-dovecot = mkIf config.flyingcircus.compat.gentoo.enable{
    description = "Create FC IO stubs dovecot";
    task = true;

    startOn = "started networking";

    script =
        ''
            mkdir -p /etc/dovecot
            touch /etc/dovecot/local.conf
            chown -R vagrant: /etc/dovecot/local.conf
          '';
  };
};
}
