{ callPackage
, buildGoModule
}:

callPackage ./generic.nix {
  inherit buildGoModule;
  version = "1.4.0";
  sha256 = "sha256-iAAnXhJdfgBsuBsuIkFQB4AbTplX3HJuf5HfUGAUEeM=";
  vendorSha256 = "sha256-kfT2UGC8Wl7CM9lOU75UqKc0/O1okGCoGDpmQntakbU=";
}
