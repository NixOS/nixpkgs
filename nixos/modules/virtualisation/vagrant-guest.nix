# Minimal configuration that vagrant depends on

{ config, pkgs, ... }:
let
  # Vagrant uses an insecure shared private key by default, but we
  # don't use the authorizedKeys attribute under users because it should be
  # removed on first boot and replaced with a random one. This script sets
  # the correct permissions and installs the temporary key if no
  # ~/.ssh/authorized_keys exists.
  install-vagrant-ssh-key = pkgs.writeScriptBin "install-vagrant-ssh-key" ''
    #!${pkgs.runtimeShell}
    if [ ! -e ~/.ssh/authorized_keys ]; then
      mkdir -m 0700 -p ~/.ssh
      echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" >> ~/.ssh/authorized_keys
      chmod 0600 ~/.ssh/authorized_keys
    fi
  '';
in
{
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Packages used by Vagrant
  environment.systemPackages = with pkgs; [
    findutils
    iputils
    nettools
    netcat
    nfs-utils
    rsync
  ];

  users.extraUsers.vagrant = {
    isNormalUser = true;
    createHome = true;
    description = "Vagrant user account";
    extraGroups = [
      "users"
      "wheel"
    ];
    home = "/home/vagrant";
    password = "vagrant";
    useDefaultShell = true;
    uid = 1000;
  };

  systemd.services.install-vagrant-ssh-key = {
    description = "Vagrant SSH key install (if needed)";
    after = [ "fs.target" ];
    wants = [ "fs.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${install-vagrant-ssh-key}/bin/install-vagrant-ssh-key";
      User = "vagrant";
      # So it won't be (needlessly) restarted:
      RemainAfterExit = true;
    };
  };

  security.sudo.wheelNeedsPassword = false;
  security.sudo-rs.wheelNeedsPassword = false;
}
