{
  curlMinimal,
  ...
}@args:

curlMinimal.override (
  {
    brotliSupport = true;
    http3Support = true;
    idnSupport = true;
    pslSupport = true;
    zstdSupport = true;
  }
  // removeAttrs args [ "curlMinimal" ]
)
