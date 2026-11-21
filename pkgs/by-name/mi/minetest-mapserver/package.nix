{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "minetest-mapserver";
  version = "4.15.0";

  src = fetchFromGitHub {
    owner = "minetest-mapserver";
    repo = "mapserver";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jB0LeSh3IpmjOpaWDyqj1zFFDEkfAGlcOTGLrjzUNcg=";
  };

  vendorHash = "sha256-ACOGlzc+dRQkKQClWcySDfiv8K5CzI7JQLXk7mDPgfE=";

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
