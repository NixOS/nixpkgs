# This module defines a systemd service that obtains the SSH key and
# host name of virtual machines running on Amazon EC2, Eucalyptus and
# OpenStack Compute (Nova).

{ config, lib, pkgs, ... }:

with lib;

{
  config = {

    systemd.services.fetch-ec2-data =
      { description = "Fetch EC2 Data";

        wantedBy = [ "multi-user.target" "sshd.service" ];
        before = [ "sshd.service" ];
        wants = [ "ip-up.target" ];
        after = [ "ip-up.target" ];

        path = [ pkgs.wget pkgs.iproute ];

        script =
          ''
            wget="wget -q --retry-connrefused -O -"

            ${optionalString (config.networking.hostName == "") ''
              echo "setting host name..."
              ${pkgs.nettools}/bin/hostname $($wget http://169.254.169.254/1.0/meta-data/hostname)
            ''}

            # Don't download the SSH key if it has already been injected
            # into the image (a Nova feature).
            if ! [ -e /root/.ssh/authorized_keys ]; then
                echo "obtaining SSH key..."
                mkdir -m 0700 -p /root/.ssh
                $wget http://169.254.169.254/1.0/meta-data/public-keys/0/openssh-key > /root/key.pub
                if [ $? -eq 0 -a -e /root/key.pub ]; then
                    cat /root/key.pub >> /root/.ssh/authorized_keys
                    echo "new key added to authorized_keys"
                    chmod 600 /root/.ssh/authorized_keys
                    rm -f /root/key.pub
                fi
            fi

            # Extract the intended SSH host key for this machine from
            # the supplied user data, if available.  Otherwise sshd will
            # generate one normally.
            $wget http://169.254.169.254/2011-01-01/user-data > /root/user-data || true

            mkdir -m 0755 -p /etc/ssh

            key="$(sed 's/|/\n/g; s/SSH_HOST_DSA_KEY://; t; d' /root/user-data)"
            key_pub="$(sed 's/SSH_HOST_DSA_KEY_PUB://; t; d' /root/user-data)"
            if [ -n "$key" -a -n "$key_pub" -a ! -e /etc/ssh/ssh_host_dsa_key ]; then
                (umask 077; echo "$key" > /etc/ssh/ssh_host_dsa_key)
                echo "$key_pub" > /etc/ssh/ssh_host_dsa_key.pub
            fi

            key="$(sed 's/|/\n/g; s/SSH_HOST_ED25519_KEY://; t; d' /root/user-data)"
            key_pub="$(sed 's/SSH_HOST_ED25519_KEY_PUB://; t; d' /root/user-data)"
            if [ -n "$key" -a -n "$key_pub" -a ! -e /etc/ssh/ssh_host_ed25519_key ]; then
                (umask 077; echo "$key" > /etc/ssh/ssh_host_ed25519_key)
                echo "$key_pub" > /etc/ssh/ssh_host_ed25519_key.pub
            fi
          '';

        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
      };

    systemd.services."print-host-key" =
      { description = "Print SSH Host Key";
        wantedBy = [ "multi-user.target" ];
        after = [ "sshd.service" ];
        script =
          ''
            # Print the host public key on the console so that the user
            # can obtain it securely by parsing the output of
            # ec2-get-console-output.
            echo "-----BEGIN SSH HOST KEY FINGERPRINTS-----" > /dev/console
            for i in /etc/ssh/ssh_host_*_key.pub; do
                ${config.programs.ssh.package}/bin/ssh-keygen -l -f $i > /dev/console
            done
            echo "-----END SSH HOST KEY FINGERPRINTS-----" > /dev/console
          '';
        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
      };

  };
}
