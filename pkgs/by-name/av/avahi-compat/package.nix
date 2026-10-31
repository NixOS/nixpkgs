{
  avahi,
  ...
}@args:

avahi.override (
  {
    withLibdnssdCompat = true;
  }
  // removeAttrs args [ "avahi" ]
)
