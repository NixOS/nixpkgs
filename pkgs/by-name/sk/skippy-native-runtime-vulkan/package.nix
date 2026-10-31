{ skippy-native-runtime }:

# nixpkgs-update: no auto update
(skippy-native-runtime.override { vulkanSupport = true; }).overrideAttrs (oldAttrs: {
  meta = oldAttrs.meta // {
    # Re-anchor meta.position here so nixpkgs-update sees the opt-out above.
    inherit (oldAttrs.meta) description;
  };
})
