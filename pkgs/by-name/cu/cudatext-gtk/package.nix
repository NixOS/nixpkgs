{ cudatext }:

# nixpkgs-update: no auto update
(cudatext.override { widgetset = "gtk3"; }).overrideAttrs (oldAttrs: {
  meta = oldAttrs.meta // {
    # Re-anchor meta.position here so nixpkgs-update sees the opt-out above.
    inherit (oldAttrs.meta) description;
  };
})
