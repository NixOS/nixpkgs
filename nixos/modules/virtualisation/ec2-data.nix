# This module defines a systemd service that obtains the SSH key and
# host name of virtual machines running on Amazon EC2, Eucalyptus and
# OpenStack Compute (Nova).

{ config, pkgs, ... }:

with pkgs.lib;

{
  options = {
    ec2.metadata = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to allow access to EC2 metadata.
      '';
    };
  };

  config = {

    systemd.services."fetch-ec2-data" =
      { description = "Fetch EC2 Data";

        wantedBy = [ "multi-user.target" ];
        before = [ "sshd.service" ];
        after = [ "network.target" ];

        path = [ pkgs.curl pkgs.iproute ];

        script =
          ''
            ip route del blackhole 169.254.169.254/32 || true

            curl="curl --retry 3 --retry-delay 0 --fail"

            echo "setting host name..."
            ${optionalString (config.networking.hostName == "") ''
              ${pkgs.nettools}/bin/hostname $($curl http://169.254.169.254/1.0/meta-data/hostname)
            ''}

            # Don't download the SSH key if it has already been injected
            # into the image (a Nova feature).
            if ! [ -e /root/.ssh/authorized_keys ]; then
                echo "obtaining SSH key..."
                mkdir -p /root/.ssh
                $curl -o /root/key.pub http://169.254.169.254/1.0/meta-data/public-keys/0/openssh-key
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
            $curl http://169.254.169.254/2011-01-01/user-data > /root/user-data || true
            key="$(sed 's/|/\n/g; s/SSH_HOST_DSA_KEY://; t; d' /root/user-data)"
            key_pub="$(sed 's/SSH_HOST_DSA_KEY_PUB://; t; d' /root/user-data)"
            if [ -n "$key" -a -n "$key_pub" -a ! -e /etc/ssh/ssh_host_dsa_key ]; then
                mkdir -m 0755 -p /etc/ssh
                (umask 077; echo "$key" > /etc/ssh/ssh_host_dsa_key)
                echo "$key_pub" > /etc/ssh/ssh_host_dsa_key.pub
            fi

            ${optionalString (! config.ec2.metadata) ''
            # Since the user data is sensitive, prevent it from being
            # accessed from now on.
            ip route add blackhole 169.254.169.254/32
            ''}
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
            ${pkgs.openssh}/bin/ssh-keygen -l -f /etc/ssh/ssh_host_dsa_key.pub > /dev/console
            echo "-----END SSH HOST KEY FINGERPRINTS-----" > /dev/console
          '';
        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
      };

  };
}
