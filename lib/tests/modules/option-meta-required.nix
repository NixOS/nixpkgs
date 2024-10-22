{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options._module.optionMeta = {
    required = lib.mkOption {
      type = types.bool;
      description = "Whether an option is required or something; just an example meta attribute for testing.";
      # Most meta options should have a default, but for this test we don't define,
      # as missingDef in ./option-meta.nix relies on this.
    };
  };
}
