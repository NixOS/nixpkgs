{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.amazonImage;
in {

  imports = [ ../../../modules/virtualisation/amazon-image.nix ];

  # Amazon recomments setting this to the highest possible value for a good EBS
  # experience, which prior to 4.15 was 255.
  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/nvme-ebs-volumes.html#timeout-nvme-ebs-volumes
  config.boot.kernelParams =
    let timeout =
      if pkgs.lib.versionAtLeast config.boot.kernelPackages.kernel.version "4.15"
      then "4294967295"
      else  "255";
    in [ "nvme_core.io_timeout=${timeout}" ];

  options.amazonImage = {
    name = mkOption {
      type = types.str;
      description = "The name of the generated derivation";
      default = "nixos-amazon-image-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}";
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
      default = "vpc";
      description = "The image format to output";
    };
  };

  config.system.build.amazonImage = import ../../../lib/make-disk-image.nix {
    inherit lib config;
    inherit (cfg) contents format name;
    pkgs = import ../../../.. { inherit (pkgs) system; }; # ensure we use the regular qemu-kvm package
    partitionTableType = if config.ec2.efi then "efi"
                         else if config.ec2.hvm then "legacy+gpt"
                         else "none";
    diskSize = cfg.sizeMB;
    fsType = "ext4";
    configFile = pkgs.writeText "configuration.nix"
      ''
        { modulesPath, ... }: {
          imports = [ "''${modulesPath}/virtualisation/amazon-image.nix" ];
          ${optionalString config.ec2.hvm ''
            ec2.hvm = true;
          ''}
          ${optionalString config.ec2.efi ''
            ec2.efi = true;
          ''}
        }
      '';
    postVM = ''
      extension=''${diskImage##*.}
      friendlyName=$out/${cfg.name}.$extension
      mv "$diskImage" "$friendlyName"
      diskImage=$friendlyName

      mkdir -p $out/nix-support
      echo "file ${cfg.format} $diskImage" >> $out/nix-support/hydra-build-products

      ${pkgs.jq}/bin/jq -n \
        --arg label ${lib.escapeShellArg config.system.nixos.label} \
        --arg system ${lib.escapeShellArg pkgs.stdenv.hostPlatform.system} \
        --arg logical_bytes "$(${pkgs.qemu}/bin/qemu-img info --output json "$diskImage" | ${pkgs.jq}/bin/jq '."virtual-size"')" \
        --arg file "$diskImage" \
        '$ARGS.named' \
        > $out/nix-support/image-info.json
    '';
  };
}
