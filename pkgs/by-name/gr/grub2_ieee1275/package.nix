{
  grub2,
  ...
}@args:

grub2.override (
  {
    ieee1275Support = true;
  }
  // removeAttrs args [ "grub2" ]
)
