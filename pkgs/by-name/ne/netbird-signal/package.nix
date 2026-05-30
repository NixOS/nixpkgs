# nixpkgs-update: no auto update
# updated via the parent 'netbird' derivation
{ netbird }:

netbird.override {
  componentName = "signal";
}
