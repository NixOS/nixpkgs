{
  libportal,
  ...
}@args:

libportal.override (
  {
    variant = "gtk4";
  }
  // removeAttrs args [ "libportal" ]
)
