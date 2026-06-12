{
  grub2,
  noMaintainersNorDependents,
  ...
}@args:

noMaintainersNorDependents (
  grub2.override (
    {
      ieee1275Support = true;
    }
    // removeAttrs args [
      "grub2"
      "noMaintainersNorDependents"
    ]
  )
)
