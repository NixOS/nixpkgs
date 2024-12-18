# This module defines a systemd service that sets the SSH host key and
# authorized client key and host name of virtual machines running on
# Amazon EC2, Eucalyptus and OpenStack Compute (Nova).

{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    (mkRemovedOptionModule [ "ec2" "metadata" ] "")
  ];

  config = {

    systemd.services.apply-ec2-data =
      { description = "Apply EC2 Data";

        wantedBy = [ "multi-user.target" "sshd.service" ];
        before = [ "sshd.service" ];
        after = ["fetch-ec2-metadata.service"];

        path = [ pkgs.iproute2 ];

        script =
          ''
            ${optionalString (config.networking.hostName == "") ''
              echo "setting host name..."
              if [ -s /etc/ec2-metadata/hostname ]; then
                  ${pkgs.nettools}/bin/hostname $(cat /etc/ec2-metadata/hostname)
              fi
            ''}

            if ! [ -e /root/.ssh/authorized_keys ]; then
                echo "obtaining SSH key..."
                mkdir -m 0700 -p /root/.ssh
                if [ -s /etc/ec2-metadata/public-keys-0-openssh-key ]; then
                    (umask 177; cat /etc/ec2-metadata/public-keys-0-openssh-key >> /root/.ssh/authorized_keys)
                    echo "new key added to authorized_keys"
                fi
            fi

            # Extract the intended SSH host key for this machine from
            # the supplied user data, if available.  Otherwise sshd will
            # generate one normally.
            userData=/etc/ec2-metadata/user-data

            mkdir -m 0755 -p /etc/ssh

            if [ -s "$userData" ]; then
              key="$(sed 's/|/\n/g; s/SSH_HOST_DSA_KEY://; t; d' $userData)"
              key_pub="$(sed 's/SSH_HOST_DSA_KEY_PUB://; t; d' $userData)"
              if [ -n "$key" -a -n "$key_pub" -a ! -e /etc/ssh/ssh_host_dsa_key ]; then
                  (umask 077; echo "$key" > /etc/ssh/ssh_host_dsa_key)
                  echo "$key_pub" > /etc/ssh/ssh_host_dsa_key.pub
              fi

              key="$(sed 's/|/\n/g; s/SSH_HOST_ED25519_KEY://; t; d' $userData)"
              key_pub="$(sed 's/SSH_HOST_ED25519_KEY_PUB://; t; d' $userData)"
              if [ -n "$key" -a -n "$key_pub" -a ! -e /etc/ssh/ssh_host_ed25519_key ]; then
                  (umask 077; echo "$key" > /etc/ssh/ssh_host_ed25519_key)
                  echo "$key_pub" > /etc/ssh/ssh_host_ed25519_key.pub
              fi
            fi
          '';

        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
      };

    systemd.services.print-host-key =
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
