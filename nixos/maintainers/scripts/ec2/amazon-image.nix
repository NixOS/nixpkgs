{ config, lib, pkgs, ... }:

with lib;

{

  imports =
    [ ../../../modules/installer/cd-dvd/channel.nix
      ../../../modules/virtualisation/amazon-image.nix
    ];

  system.build.amazonImage = import ../../../lib/make-disk-image.nix {
    inherit pkgs lib config;
    partitioned = config.ec2.hvm;
    diskSize = 8192;
    configFile = pkgs.writeText "configuration.nix"
      ''
        {
          imports = [ <nixpkgs/nixos/modules/virtualisation/amazon-image.nix> ];
          ${optionalString config.ec2.hvm ''
            ec2.hvm = true;
          ''}
        }
      '';
  };

}
