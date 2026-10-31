{
  lib,
  ...
}:
{
  imports = [
    ./disk-size-option.nix
    (lib.mkRenamedOptionModuleWith {
      sinceRelease = 2411;
      from = [
        "oci"
        "diskSize"
      ];
      to = [
        "virtualisation"
        "diskSize"
      ];
    })
  ];

  options = {
    oci = {
      efi = lib.mkOption {
        default = true;
        internal = true;
        description = ''
          Whether the OCI instance is using EFI.
        '';
      };

      copyChannel = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to copy the NixOS channel into the image.

          When enabled, the nixpkgs source tree is bundled into the image at
          `/nix/var/nix/profiles/per-user/root/channels/nixos`, allowing
          `nix-channel`, `nixos-rebuild`, and `<nixpkgs>` to work without
          network access.

          Disable this to reduce image size by ~300-400MB, especially when
          using flakes where channels are not needed.
        '';
      };
    };
  };
}
