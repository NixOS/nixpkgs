{
  libportal,
  ...
}@args:

libportal.override (
  {
    variant = "gtk3";
  }
  // removeAttrs args [ "libportal" ]
)
