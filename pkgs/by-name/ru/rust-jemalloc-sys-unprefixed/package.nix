{
  rust-jemalloc-sys,
  ...
}@args:

rust-jemalloc-sys.override (
  {
    unprefixed = true;
  }
  // removeAttrs args [ "rust-jemalloc-sys" ]
)
