{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "minetest-mapserver";
  version = "4.9.3";

  src = fetchFromGitHub {
    owner = "minetest-mapserver";
    repo = "mapserver";
    rev = "v${version}";
    hash = "sha256-6tDhfYG/zcFjGNCR6yir71FM/qFHK5p/3+q+P6V1a4c=";
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
  };
}
