{
  buildGoModule,
  pname,
  src,
  version,
  vendorHash,
}:
buildGoModule {
  inherit
    pname
    src
    version
    vendorHash
    ;
}
