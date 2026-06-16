{
  libportal,
  ...
}@args:

libportal.override (
  {
    variant = "qt5";
  }
  // removeAttrs args [ "libportal" ]
)
