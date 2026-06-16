{
  libva-minimal,
  ...
}@args:

libva-minimal.override (
  {
    minimal = false;
  }
  // removeAttrs args [ "libva-minimal" ]
)
