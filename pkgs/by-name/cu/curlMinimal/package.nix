{
  curl,
  ...
}@args:

curl.override (
  {
    brotliSupport = false;
    http3Support = false;
    idnSupport = false;
    pslSupport = false;
    zstdSupport = false;
  }
  // removeAttrs args [ "curl" ]
)
