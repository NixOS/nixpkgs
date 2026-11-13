{
  libubox,
  ...
}@args:

libubox.override (
  {
    with_ustream_ssl = false;
  }
  // removeAttrs args [ "libubox" ]
)
