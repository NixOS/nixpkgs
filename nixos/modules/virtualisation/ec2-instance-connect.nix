{ config, lib, pkgs, ... }:

let
  cfg = config.ec2.instance-connect;
in
{
  options = {
    ec2.instance-connect.enable = lib.mkEnableOption "EC2 Instance Connect";
  };

  config = lib.mkIf cfg.enable {
    users.users.ec2-instance-connect = {
      isSystemUser = true;
    };

    systemd.services.ec2-intance-connect = {
      description = "EC2 Instance Connect Host Key Harvesting";
      after = [ "ssh.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.ec2-instance-connect}/bin/eic_harvest_hostkeys";
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };

    services.openssh.extraConfig = ''
      AuthorizedKeysCommand /etc/ssh/authorized_keys_command_eic_run_authorized_keys %u %f
      AuthorizedKeysCommandUser ec2-instance-connect
    '';

    # Ugly: sshd refuses to start if a store path is given because
    # /nix/store is group-writable.  So indirect by a symlink.
    # Another instance of this is found in the Google OS Login module
    environment.etc."ssh/authorized_keys_command_eic_run_authorized_keys" = {
      mode = "0755";
      text = ''
        #!/bin/sh
        exec ${pkgs.ec2-instance-connect}/bin/eic_run_authorized_keys "$@"
      '';
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ thefloweringash ];
  };
}
