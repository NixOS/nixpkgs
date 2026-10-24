{ mesh-llm }:

# nixpkgs-update: no auto update
(mesh-llm.override { cudaSupport = true; }).overrideAttrs (oldAttrs: {
  meta = oldAttrs.meta // {
    # Re-anchor meta.position here so nixpkgs-update sees the opt-out above.
    inherit (oldAttrs.meta) description;
  };
})
