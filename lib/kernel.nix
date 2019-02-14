{ lib, version ? null }:

with lib;
rec {
  # Common patterns/legacy
  whenAtLeast = ver: mkIf (versionAtLeast version ver);
  whenOlder   = ver: mkIf (versionOlder version ver);
  # range is (inclusive, exclusive)
  whenBetween = verLow: verHigh: mkIf (versionAtLeast version verLow && versionOlder version verHigh);


  # Keeping these around in case we decide to change this horrible implementation :)
  option = x:
      x // { optional = true; };

  yes      = { tristate    = "y"; };
  no       = { tristate    = "n"; };
  enable   = { tristate    = "e"; };
  module   = { tristate    = "m"; };
  freeform = x: { freeform = x; };

  # copy/pasted from boot/kernel.nix
      isYes = option: {
        assertion = config: config.isYes option;
        message = "CONFIG_${option} is not yes!";
        configLine = "CONFIG_${option}=y";
      };

      isNo = option: {
        assertion = config: config.isNo option;
        message = "CONFIG_${option} is not no!";
        configLine = "CONFIG_${option}=n";
      };

      isModule = option: {
        assertion = config: config.isModule option;
        message = "CONFIG_${option} is not built as a module!";
        configLine = "CONFIG_${option}=m";
      };

      ### Usually you will just want to use these two
      # True if yes or module
      isEnabled = option: {
        assertion = config: config.isEnabled option;
        message = "CONFIG_${option} is not enabled!";
        configLine = "CONFIG_${option}=y";
      };

      # True if no or omitted
      isDisabled = option: {
        assertion = config: config.isDisabled option;
        message = "CONFIG_${option} is not disabled!";
        configLine = "CONFIG_${option}=n";
      };

}
