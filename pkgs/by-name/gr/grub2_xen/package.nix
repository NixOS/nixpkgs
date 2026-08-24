{
  grub2,
  ...
}@args:

grub2.override (
  {
    xenSupport = true;
  }
  // removeAttrs args [ "grub2" ]
)
