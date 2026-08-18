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
    scpSupport = !stdenv.hostPlatform.isSunOS && !stdenv.hostPlatform.isCygwin;
    zstdSupport = true;

    gssSupport = !(curlMinimal.override { gssSupport = true; }).meta.broken;
  }
  // removeAttrs args [ "curlMinimal" ]
)
