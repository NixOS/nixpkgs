{
  libportal,
  ...
}@args:

libportal.override (
  {
    variant = "qt6";
  }
  // removeAttrs args [ "libportal" ]
)
