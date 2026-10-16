{
  config,
  lib,
  ...
}:
let
  cfg = config.security;
in
{
  options = {
    security.lsm = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        A list of the LSMs to initialize in order.
      '';
    };
  };

  config = lib.mkMerge [
    {
      # We set the default LSM's here due to them not being present if set when enabling AppArmor.
      security.lsm = lib.mkMerge [
        [
          "landlock"
          "yama"
        ]
        # Load BPF last unconditionally. See: https://github.com/NixOS/nixpkgs/pull/533428.
        # Apparmor (and potentially other modules) will load incorrectly if they are not before BPF.
        # It is believed that there was a regression between kernel 6.12 and 6.18 which caused the
        # passthrough stub or LSM stacking of the BPF module to interact with other modules incorrectly.
        (lib.mkAfter [ "bpf" ])
      ];
    }
    (lib.mkIf (lib.lists.length cfg.lsm > 0) {
      assertions = [
        {
          assertion = builtins.length (lib.filter (lib.hasPrefix "security=") config.boot.kernelParams) == 0;
          message = "security parameter in boot.kernelParams cannot be used when security.lsm is used";
        }
      ];

      boot.kernelParams = [
        "lsm=${lib.concatStringsSep "," cfg.lsm}"
      ];
    })
  ];
}
