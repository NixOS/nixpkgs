{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "minetest-mapserver";
  version = "4.10.0";

  src = fetchFromGitHub {
    owner = "minetest-mapserver";
    repo = "mapserver";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PlujCCZH+Gm9OgK/kqKvqnLv7sgHED4rP6/tmx6IFBI=";
  };

  vendorHash = "sha256-ncb0WOLby2j6+SeyVJ31szxVLDyucRjqN7vwMqitoHQ=";

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
