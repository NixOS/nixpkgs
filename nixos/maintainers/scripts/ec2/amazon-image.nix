{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.amazonImage;
in {

  imports = [ ../../../modules/virtualisation/amazon-image.nix ];

  # Required to provide good EBS experience,
  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/nvme-ebs-volumes.html#timeout-nvme-ebs-volumes
  # TODO change value to 4294967295 when kernel is updated to 4.15 or later
  config.boot.kernelParams = [ "nvme_core.io_timeout=255" ];

  options.amazonImage = {
    name = mkOption {
      type = types.str;
      description = "The name of the generated derivation";
      default = "nixos-disk-image";
    };

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

    sizeMB = mkOption {
      type = types.int;
      default = if config.ec2.hvm then 2048 else 8192;
      description = "The size in MB of the image";
    };

    format = mkOption {
      type = types.enum [ "raw" "qcow2" "vpc" ];
      default = "qcow2";
      description = "The image format to output";
    };
  };

  config.system.build.amazonImage = import ../../../lib/make-disk-image.nix {
    inherit lib config;
    inherit (cfg) contents format name;
    pkgs = import ../../../.. { inherit (pkgs) system; }; # ensure we use the regular qemu-kvm package
    partitionTableType = if config.ec2.hvm then "legacy" else "none";
    diskSize = cfg.sizeMB;
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
