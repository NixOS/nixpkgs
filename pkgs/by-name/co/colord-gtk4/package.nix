{
  colord-gtk,
  ...
}@args:

colord-gtk.override (
  {
    withGtk4 = true;
  }
  // removeAttrs args [ "colord-gtk" ]
)
