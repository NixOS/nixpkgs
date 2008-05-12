dd if=/dev/zero of=/dev/sda bs=1048576 count=1

sfdisk /dev/sda -uM << EOF
,512,L
,1024,S
,,L
EOF

mkfs.ext3 /dev/sda1 ; mkswap /dev/sda2 ; mkfs.ext3 /dev/sda3

mount /dev/sda3 /mnt ; mkdir /mnt/boot ; mount /dev/sda1 /mnt/boot

mkdir -p /mnt/etc/nixos

cat > /mnt/etc/nixos/configuration.nix <<EOF

{
  boot = {
    grubDevice = "/dev/sda";
    copyKernels = true;
    bootMount = "(hd0,0)";
  };

  fileSystems = [
    { mountPoint = "/";
      device = "/dev/sda3";
    }
    { mountPoint = "/boot";
      device = "/dev/sda1";
      neededForBoot = true;
    }
  ];

  swapDevices = [
    { device = "/dev/sda2"; }
  ];
  
  services = {
    sshd = {
      enable = true;
    };
  };

  fonts = { 
    enableFontConfig = false; 
  };

}

EOF

nixos-install

