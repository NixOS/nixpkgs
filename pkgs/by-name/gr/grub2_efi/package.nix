{
  grub2,
  ...
}@args:

grub2.override (
  {
    efiSupport = true;
  }
  // removeAttrs args [ "grub2" ]
)
