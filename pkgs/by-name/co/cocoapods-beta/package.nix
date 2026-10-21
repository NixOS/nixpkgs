{
  lib,
  cocoapods,
}:

lib.lowPrio (
  cocoapods.override {
    beta = true;
  }
)
