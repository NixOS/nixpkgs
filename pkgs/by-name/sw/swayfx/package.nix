{
  lib,
  swayfx-unwrapped,
  sway,
  # Used by the NixOS module:
  withBaseWrapper ? true,
  extraSessionCommands ? "",
  withGtkWrapper ? false,
  extraOptions ? [ ], # E.g.: [ "--verbose" ]
  isNixOS ? false,
  enableXWayland ? true,
  dbusSupport ? true,
}:

sway.override {
  inherit
    withBaseWrapper
    extraSessionCommands
    withGtkWrapper
    extraOptions
    isNixOS
    enableXWayland
    dbusSupport
    ;
  sway-unwrapped = swayfx-unwrapped;
}
