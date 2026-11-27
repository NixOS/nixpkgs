{
  optifinePackages,
  noMaintainersNorDependents,
  ...
}@args:

# The latest OptiFine; see default.nix.
# Override arguments are passed on to generic.nix.
noMaintainersNorDependents (
  optifinePackages.optifine-latest.override (
    removeAttrs args [
      "optifinePackages"
      "noMaintainersNorDependents"
    ]
  )
)
