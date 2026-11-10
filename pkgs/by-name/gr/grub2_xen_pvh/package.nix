{
  grub2,
  ...
}@args:

grub2.override (
  {
    xenPvhSupport = true;
  }
  // removeAttrs args [ "grub2" ]
)
