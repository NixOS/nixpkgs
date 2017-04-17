{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.amazonImage;
in {

  imports =
    [ ../../../modules/installer/cd-dvd/channel.nix
      ../../../modules/virtualisation/amazon-image.nix
    ];

  options.amazonImage = {
    contents = mkOption {
      example = literalExample ''
        [ { source = pkgs.memtest86 + "/memtest.bin";
            target = "boot/memtest.bin";
          }
        ]
      '';
      default = [];
      description = ''
        This option lists files to be copied to fixed locations in the
        generated image. Glob patterns work.
      '';
    };
  };

  config.system.build.amazonImage = import ../../../lib/make-disk-image.nix {
    inherit lib config;
    inherit (cfg) contents;
    pkgs = import ../../../.. { inherit (pkgs) system; }; # ensure we use the regular qemu-kvm package
    partitioned = config.ec2.hvm;
    diskSize = if config.ec2.hvm then 2048 else 8192;
    format = "qcow2";
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
