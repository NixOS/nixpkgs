{
  callPackage,
  timeshift-unwrapped,
}:
let
  timeshift-wrapper = callPackage ./wrapper.nix { };
in
(timeshift-wrapper timeshift-unwrapped [ ]).overrideAttrs (oldAttrs: {
  meta = oldAttrs.meta // {
    description = oldAttrs.meta.description + " (without runtime dependencies)";
    longDescription = oldAttrs.meta.longDescription + ''
      This package is a wrapped version of timeshift-unwrapped
      without runtime dependencies of command utilities.
    '';
  };
})
