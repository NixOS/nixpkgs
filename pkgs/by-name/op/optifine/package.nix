{
  optifinePackages,
  ...
}@args:

# The latest OptiFine; see default.nix.
# Override arguments are passed on to generic.nix.
optifinePackages.optifine-latest.override (removeAttrs args [ "optifinePackages" ])
