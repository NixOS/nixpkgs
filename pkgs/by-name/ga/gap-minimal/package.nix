{
  lib,
  gap,
  ...
}@args:

lib.lowPrio (
  gap.override (
    {
      packageSet = "minimal";
    }
    // removeAttrs args [
      "gap"
      "lib"
    ]
  )
)
