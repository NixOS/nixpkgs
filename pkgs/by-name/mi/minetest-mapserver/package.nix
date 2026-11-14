{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "minetest-mapserver";
  version = "4.11.0";

  src = fetchFromGitHub {
    owner = "minetest-mapserver";
    repo = "mapserver";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZQs19mM92/89j6WwIdd6z9zAO3TWL7n1qJrIGVd3mis=";
  };

  vendorHash = "sha256-ASNDIlb2X9CsTwhNxYYAUX0UYsna5gLUpnoh0l3EUxM=";

  meta = {
    description = "Realtime mapserver for minetest";
    mainProgram = "mapserver";
    homepage = "https://github.com/minetest-mapserver/mapserver/blob/master/readme.md";
    changelog = "https://github.com/minetest-mapserver/mapserver/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      cc-by-sa-30
    ];
    platforms = lib.platforms.all;
  };
})
