{
  lib,
  cocoapods,
  noMaintainersNorDependents,
}:

lib.lowPrio (
  noMaintainersNorDependents (
    cocoapods.override {
      beta = true;
    }
  )
)
