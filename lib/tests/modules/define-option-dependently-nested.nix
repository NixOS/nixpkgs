{ lib, options, ... }:

# Some modules may be distributed separately and need to adapt to other modules
# that are distributed and versioned separately.
{

  # Always defined, but the value depends on the presence of an option.
  config.set = {
    value = if options ? set.enable then 360 else 7;
  }
  # Only define if possible.
  // lib.optionalAttrs (options ? set.enable) {
    enable = true;
  };

}
