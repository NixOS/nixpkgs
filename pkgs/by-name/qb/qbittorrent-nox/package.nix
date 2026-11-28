{ qbittorrent }:

# nixpkgs-update: no auto update
(qbittorrent.override { guiSupport = false; }).overrideAttrs (oldAttrs: {
  meta = oldAttrs.meta // {
    # Re-anchor meta.position here so nixpkgs-update sees the opt-out above.
    inherit (oldAttrs.meta) description;
  };
})
