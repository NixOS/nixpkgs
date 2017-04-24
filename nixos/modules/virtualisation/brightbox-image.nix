{ config, lib, pkgs, ... }:

with lib;
let
  diskSize = 20 * 1024; # MB
in
{
  imports = [ ../profiles/headless.nix ../profiles/qemu-guest.nix ];

  system.build.brightboxImage = import ../../lib/make-disk-image.nix {
    name = "brightbox-image";
    configFile = ./brightbox-config.nix;
    format = "qcow2";
    inherit diskSize;
    inherit config lib pkgs;
  };

  fileSystems."/".label = "nixos";

  # Generate a GRUB menu.  Amazon's pv-grub uses this to boot our kernel/initrd.
  boot.loader.grub.device = "/dev/vda";
  boot.loader.timeout = 0;

  # Don't put old configurations in the GRUB menu.  The user has no
  # way to select them anyway.
  boot.loader.grub.configurationLimit = 0;

  # Allow root logins only using the SSH key that the user specified
  # at instance creation time.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "prohibit-password";

  # Force getting the hostname from Google Compute.
  networking.hostName = mkDefault "";

  # Always include cryptsetup so that NixOps can use it.
  environment.systemPackages = [ pkgs.cryptsetup ];

  systemd.services."fetch-ec2-data" =
    { description = "Fetch EC2 Data";

      wantedBy = [ "multi-user.target" "sshd.service" ];
      before = [ "sshd.service" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      path = [ pkgs.wget pkgs.iproute ];

      script =
        ''
          wget="wget -q --retry-connrefused -O -"

          ${optionalString (config.networking.hostName == "") ''
            echo "setting host name..."
            ${pkgs.nettools}/bin/hostname $($wget http://169.254.169.254/latest/meta-data/hostname)
          ''}

          # Don't download the SSH key if it has already been injected
          # into the image (a Nova feature).
          if ! [ -e /root/.ssh/authorized_keys ]; then
              echo "obtaining SSH key..."
              mkdir -m 0700 -p /root/.ssh
              $wget http://169.254.169.254/latest/meta-data/public-keys/0/openssh-key > /root/key.pub
              if [ $? -eq 0 -a -e /root/key.pub ]; then
                  if ! grep -q -f /root/key.pub /root/.ssh/authorized_keys; then
                      cat /root/key.pub >> /root/.ssh/authorized_keys
                      echo "new key added to authorized_keys"
                  fi
                  chmod 600 /root/.ssh/authorized_keys
                  rm -f /root/key.pub
              fi
          fi

          # Extract the intended SSH host key for this machine from
          # the supplied user data, if available.  Otherwise sshd will
          # generate one normally.
          $wget http://169.254.169.254/2011-01-01/user-data > /root/user-data || true
          key="$(sed 's/|/\n/g; s/SSH_HOST_DSA_KEY://; t; d' /root/user-data)"
          key_pub="$(sed 's/SSH_HOST_DSA_KEY_PUB://; t; d' /root/user-data)"
          if [ -n "$key" -a -n "$key_pub" -a ! -e /etc/ssh/ssh_host_dsa_key ]; then
              mkdir -m 0755 -p /etc/ssh
              (umask 077; echo "$key" > /etc/ssh/ssh_host_dsa_key)
              echo "$key_pub" > /etc/ssh/ssh_host_dsa_key.pub
          fi
        '';

      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = true;
    };

}
