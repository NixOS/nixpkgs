{ lib, options, ... }:

# Some modules may be distributed separately and need to adapt to other modules
# that are distributed and versioned separately.
{

  # Always defined, but the value depends on the presence of an option.
  config = {
    value = if options ? enable then 360 else 7;
  } 
  # Only define if possible.
  // lib.optionalAttrs (options ? enable) {
    enable = true;
  };

}
