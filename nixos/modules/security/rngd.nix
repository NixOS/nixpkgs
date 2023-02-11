{ lib, ... }:
let
  removed = k: lib.mkRemovedOptionModule [ "security" "rngd" k ];
in
{
  imports = [
    (removed "enable" ''
       rngd is not necessary for any device that the kernel recognises
       as an hardware RNG, as it will automatically run the krngd task
       to periodically collect random data from the device and mix it
       into the kernel's RNG.
    '')
    (removed "debug"
      "The rngd module was removed, so its debug option does nothing.")
  ];
}
