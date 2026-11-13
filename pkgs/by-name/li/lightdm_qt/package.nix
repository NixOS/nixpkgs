{
  lightdm,
  ...
}@args:

lightdm.override (
  {
    withQt5 = true;
  }
  // removeAttrs args [ "lightdm" ]
)
