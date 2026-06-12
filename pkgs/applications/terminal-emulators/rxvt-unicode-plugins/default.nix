{ callPackage }:
let
  _callPackage = callPackage;
in
let
  callPackage =
    file: args:
    (_callPackage file args).overrideAttrs (old: {
      # rxvt-unicode by default includes all plugins, so they always have a dependent,
      # meaning we should really set hasNoMaintainersButDependents for the plugins that don't have a maintainer,
      # but CI strictly requires the packages attribute be found somewhere if that attribute is set,
      # which the `attrValues rxvt-unicode-plugins` used by rxvt-unicode doesn't trigger..
      # So we need to silence the maintainerless warning in another way, which is what requiresMaintainers is for
      meta = old.meta // {
        requiresMaintainers = false;
      };
    });
in
{
  autocomplete-all-the-things = callPackage ./urxvt-autocomplete-all-the-things { };

  bidi = callPackage ./urxvt-bidi { };

  font-size = callPackage ./urxvt-font-size { };

  perl = callPackage ./urxvt-perl { };

  perls = callPackage ./urxvt-perls { };

  resize-font = callPackage ./urxvt-resize-font { };

  tabbedex = callPackage ./urxvt-tabbedex { };

  theme-switch = callPackage ./urxvt-theme-switch { };

  vtwheel = callPackage ./urxvt-vtwheel { };

}
