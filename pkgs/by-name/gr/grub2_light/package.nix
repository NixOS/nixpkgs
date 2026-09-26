{
  grub2,
  ...
}@args:

grub2.override (
  {
    zfsSupport = false;
  }
  // removeAttrs args [ "grub2" ]
)
