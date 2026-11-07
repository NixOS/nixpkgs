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
    (lib.mkRenamedOptionModuleWith {
      sinceRelease = 2611;
      from = [
        "oci"
        "efi"
      ];
      to = [
        "oracleCloudInfra"
        "efi"
      ];
    })
  ];

  options = {
    oracleCloudInfra = {
      efi = lib.mkOption {
        default = true;
        internal = true;
        description = ''
          Whether the Oracle Cloud Infrastructure instance is using EFI.
        '';
      };
    };
  };
}
