{
  curlMinimal,
  ...
}@args:

let
  inherit (curlMinimal) stdenv;
in
curlMinimal.override (
  {
    brotliSupport = true;
    http3Support = true;
    idnSupport = true;
    pslSupport = true;
    zstdSupport = true;

    gssSupport = !(curlMinimal.override { gssSupport = true; }).meta.broken;
  }
  // removeAttrs args [ "curlMinimal" ]
)
