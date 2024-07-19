{ config, lib, ... }:
let
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.options) mkOption;
  inherit (lib.trivial) const;
in
{
  options.data.indices = mapAttrs (const mkOption) {
    packageInfo = {
      description = "Index of packageInfo.";
      type = config.types.indexOf config.types.packageInfo;
      default = { };
      # Given them empty defaults to avoid breaking evaluation when the index has not been generated.
      # A true default value would require impure derivations to run and access the internet.
    };
  };
}
