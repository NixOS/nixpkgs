# Use `glimpse-with-plugins` package for Glimpse with all plug-ins.
# If you just want a subset of plug-ins, you can specify them explicitly:
# `glimpse-with-plugins.override { plugins = with glimpsePlugins; [ gap ]; }`.

{ gimpPlugins, glimpse }:

# This attrs can be extended in the future if there happen to be glimpse-only
# plugins or some that need further modification in order to work with Glimpse.
gimpPlugins.overrideScope' (self: super: {
  gimp = glimpse;
})
