{ config, lib, ... }:
with lib;
let
  cfg = config;
in
{
  options.kernelAtleast = mkOption {
    type = types.listOf types.optionSet;
    options =
      [ { version = mkOption {
            type = types.str;
            example = "4.4";
            description =
              "Issue warning when kernel version is below this number.";
          };
          msg = mkOption {
            type = types.str;
            example = "";
          };
        }
      ];
  };

  config.warnings = builtins.concatLists (map
    (x: if (builtins.compareVersions cfg.boot.kernelPackages.kernel.version x.version) == -1
        then [ "${x.msg} (${cfg.boot.kernelPackages.kernel.version} < ${x.version})" ]
        else [ ]
    ) cfg.kernelAtleast
  );

}
