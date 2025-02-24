{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "minetest-mapserver";
  version = "4.9.2";

  src = fetchFromGitHub {
    owner = "minetest-mapserver";
    repo = "mapserver";
    rev = "v${version}";
    hash = "sha256-wo3/7axVkEcnqkOG29KE136EeMt/FW63q68UlpIA3z8=";
  };

  vendorHash = "sha256-P3+M1ciRmFbOFnjy1+oWPhngPYFe/5o6Cs8pRlYNx2Q=";

  meta = with lib; {
    description = "Realtime mapserver for minetest";
    mainProgram = "mapserver";
    homepage = "https://github.com/minetest-mapserver/mapserver/blob/master/readme.md";
    changelog = "https://github.com/minetest-mapserver/mapserver/releases/tag/v${version}";
    license = with licenses; [
      mit
      cc-by-sa-30
    ];
    platforms = platforms.all;
    maintainers = with maintainers; [ gm6k ];
  };
}
