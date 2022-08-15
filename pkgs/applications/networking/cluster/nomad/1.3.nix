{ callPackage
, buildGoModule
}:

callPackage ./generic.nix {
  inherit buildGoModule;
  version = "1.3.3";
  sha256 = "sha256-/63QGknivXyBel2MhMzbh/rE+UrfV3mb+zPZzOU15WU=";
  vendorSha256 = "sha256-5ubJ6hgpdkZd/hwy+u2S6XgQLD5xmgUnaUqJoLdguBQ=";
}
