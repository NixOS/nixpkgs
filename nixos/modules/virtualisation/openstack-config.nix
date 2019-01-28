{ pkgs, lib, ... }:

with lib;

{
  imports = [
    ../profiles/qemu-guest.nix
    ../profiles/headless.nix
    # The Openstack Metadata service exposes data on an EC2 API also.
    ./ec2-data.nix
    ./amazon-init.nix
  ];

  config = {
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      autoResize = true;
    };

    boot.growPartition = true;
    boot.kernelParams = [ "console=ttyS0" ];
    boot.loader.grub.device = "/dev/vda";
    boot.loader.timeout = 0;

    # Allow root logins
    services.openssh = {
      enable = true;
      permitRootLogin = "prohibit-password";
      passwordAuthentication = mkDefault false;
    };

    systemd.services.openstack-init = {
      path = [ pkgs.wget ];
      description = "Fetch Metadata on startup";
      wantedBy = [ "multi-user.target" ];
      before = [ "apply-ec2-data.service" "amazon-init.service"];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      script =
        ''
          metaDir=/etc/ec2-metadata
          mkdir -m 0755 -p "$metaDir"

          echo "getting Openstack instance metadata (via EC2 API)..."
          if ! [ -e "$metaDir/ami-manifest-path" ]; then
            wget --retry-connrefused -O "$metaDir/ami-manifest-path" http://169.254.169.254/1.0/meta-data/ami-manifest-path
          fi

          if ! [ -e "$metaDir/user-data" ]; then
            wget --retry-connrefused -O "$metaDir/user-data" http://169.254.169.254/1.0/user-data && chmod 600 "$metaDir/user-data"
          fi

          if ! [ -e "$metaDir/hostname" ]; then
            wget --retry-connrefused -O "$metaDir/hostname" http://169.254.169.254/1.0/meta-data/hostname
          fi

          if ! [ -e "$metaDir/public-keys-0-openssh-key" ]; then
            wget --retry-connrefused -O "$metaDir/public-keys-0-openssh-key" http://169.254.169.254/1.0/meta-data/public-keys/0/openssh-key
          fi
        '';
      restartIfChanged = false;
      unitConfig.X-StopOnRemoval = false;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };
  };
}
