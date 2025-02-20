# An interactive image built using systemd-repart.
#
# This is a higher-level abstraction built on top of repart.nix but designed
# to give you an interactive (i.e. with Nix available and working image.) image.
#
# You can use this by importing this module in your config.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  rootPartitionLabel = "root";

  closureInfo = pkgs.closureInfo {
    rootPaths = [ config.system.build.toplevel ];
  };

  # Build the nix state at /nix/var/nix for the image
  #
  # This does two things:
  # (1) Setup the initial profile
  # (2) Create an initial Nix DB so that the nix tools work
  nixState = pkgs.runCommand "nix-state" { nativeBuildInputs = [ pkgs.buildPackages.nix ]; } ''
    mkdir -p $out/profiles
    ln -s ${config.system.build.toplevel} $out/profiles/system-1-link
    ln -s /nix/var/nix/profiles/system-1-link $out/profiles/system

    export NIX_STATE_DIR=$out
    nix-store --load-db < ${closureInfo}/registration
  '';
in
{

  imports = [ ./repart.nix ];

  assertions = [
    {
      assertion = !config.boot.loader.grub.enable;
      message = "You cannot use an interactive repart image with grub.";
    }
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-partlabel/${rootPartitionLabel}";
      fsType = "ext4";
    };
  };
  # By not providing an entry in fileSystems for the ESP, systemd will
  # automount it to `/efi`.
  boot.loader.efi.efiSysMountPoint = "/efi";

  system.image = {
    id = config.system.name;
    version = config.system.nixos.version;
  };

  image.repart = {
    name = config.system.name;
    partitions = {
      "esp" = {
        # Populate the ESP statically so that we can boot this image.
        contents =
          let
            efiArch = config.nixpkgs.hostPlatform.efiArch;
          in
          {
            "/EFI/BOOT/BOOT${lib.toUpper efiArch}.EFI".source = "${config.systemd.package}/lib/systemd/boot/efi/systemd-boot${efiArch}.efi";
            "/EFI/systemd/systemd-bootx64.efi".source = "${config.systemd.package}/lib/systemd/boot/efi/systemd-boot${efiArch}.efi";
            "/EFI/Linux/${config.system.boot.loader.ukiFile}".source = "${config.system.build.uki}/${config.system.boot.loader.ukiFile}";
          };
        repartConfig = {
          Type = "esp";
          Format = "vfat";
          SizeMinBytes = if config.nixpkgs.hostPlatform.isx86_64 then "64M" else "96M";
        };
      };
      "root" = {
        storePaths = [ config.system.build.toplevel ];
        contents = {
          "/nix/var/nix".source = nixState;
        };
        repartConfig = {
          Type = "root";
          Format = config.fileSystems."/".fsType;
          Label = rootPartitionLabel;
          Minimize = "guess";
        };
      };
    };
  };

}
