final: prev: {
  wayfirePlugins = prev.wayfirePlugins.overrideScope (wfinal: wprev: {
    wayfire-plugins-extra = wprev.wayfire-plugins-extra.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        ../packages/wayfire-plugins-extra/water-persistent.patch
      ];
    });
    wcm = wprev.wcm.overrideAttrs (old: {
      # Add patch if necessary, for now it relies on wayfire-plugins-extra metadata
    });
  });
}
