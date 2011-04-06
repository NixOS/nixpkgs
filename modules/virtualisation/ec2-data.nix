# This module defines an Upstart job that obtains the SSH key and host
# name of virtual machines running on Amazon EC2, Eucalyptus and
# OpenStack Compute (Nova).

{ config, pkgs, ... }:

{

  jobs.fetchEC2Data =
    { name = "fetch-ec2-data";

      startOn = "ip-up";

      task = true;

      script =
        ''
          echo "setting host name..."
          ${pkgs.nettools}/bin/hostname $(${pkgs.curl}/bin/curl http://169.254.169.254/1.0/meta-data/hostname)

          # Don't download the SSH key if it has already been injected
          # into the image (a Nova feature).
          if ! [ -e /root/.ssh/authorized_keys ]; then
              echo "obtaining SSH key..."
              mkdir -p /root/.ssh
              ${pkgs.curl}/bin/curl --retry 3 --retry-delay 0 --fail \
                -o /root/key.pub \
                http://169.254.169.254/1.0/meta-data/public-keys/0/openssh-key
              if [ $? -eq 0 -a -e /root/key.pub ]; then
                  if ! grep -q -f /root/key.pub /root/.ssh/authorized_keys; then
                      cat /root/key.pub >> /root/.ssh/authorized_keys
                      echo "new key added to authorized_keys"
                  fi
                  chmod 600 /root/.ssh/authorized_keys
                  rm -f /root/key.pub
              fi
          fi

          # Print the host public key on the console so that the user
          # can obtain it securely by parsing the output of
          # ec2-get-console-output.
          echo "-----BEGIN SSH HOST KEY FINGERPRINTS-----" > /dev/console
          ${pkgs.openssh}/bin/ssh-keygen -l -f /etc/ssh/ssh_host_dsa_key.pub > /dev/console
          echo "-----END SSH HOST KEY FINGERPRINTS-----" > /dev/console
        '';
    };


}
