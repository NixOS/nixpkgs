{
  lib,
  buildGoModule,
  pname,
  src,
}:
(buildGoModule {
  inherit pname src;
  inherit (lib.importJSON ./version.json) version vendorHash;
})
