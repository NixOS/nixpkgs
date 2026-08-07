{
  lib,
  gap,
  ...
}@args:

lib.lowPrio (
  gap.override (
    {
      packageSet = "full";
    }
    // removeAttrs args [
      "gap"
      "lib"
    ]
  )
)
