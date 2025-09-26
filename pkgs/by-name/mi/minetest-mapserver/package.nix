{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "minetest-mapserver";
  version = "4.9.4";

  src = fetchFromGitHub {
    owner = "minetest-mapserver";
    repo = "mapserver";
    rev = "v${version}";
    hash = "sha256-YKJbqD0dtQGLXDRLOwLl6E5R36gftDD98+/XpTGwZSk=";
  };

  vendorHash = "sha256-sPqwY3c/ehrrP6aeUyRUMqCpHqBErwIXUlgoX0P99/w=";

  meta = {
    description = "Realtime mapserver for minetest";
    mainProgram = "mapserver";
    homepage = "https://github.com/minetest-mapserver/mapserver/blob/master/readme.md";
    changelog = "https://github.com/minetest-mapserver/mapserver/releases/tag/v${version}";
    license = with lib.licenses; [
      mit
      cc-by-sa-30
    ];
    platforms = lib.platforms.all;
  };
}
