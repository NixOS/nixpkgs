{ llama-cpp }:

# nixpkgs-update: no auto update
(llama-cpp.override { rocmSupport = true; }).overrideAttrs (oldAttrs: {
  meta = oldAttrs.meta // {
    # Re-anchor meta.position here so nixpkgs-update sees the opt-out above.
    inherit (oldAttrs.meta) description;
  };
})
