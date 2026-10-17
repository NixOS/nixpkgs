{
  lib,
  gap,
}:

lib.lowPrio (
  gap.override {
    packageSet = "full";
  }
)
