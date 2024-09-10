{
  lib,
  ...
}:
let
  virtualisationOptions = import ./virtualisation-options.nix;
in
{
  imports = [
    virtualisationOptions.diskSize
    (lib.mkRenamedOptionModuleWith {
      sinceRelease = 2411;
      from = [
        "virtualisation"
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
    };
  };
}
