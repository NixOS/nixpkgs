{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "minetest-mapserver";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "mapserver";
    rev = "v${version}";
    hash = "sha256-qThdNXb17mh3Ph57d3oUl/KhP64AKPZJOCVsvr2SDWk=";
  };

  vendorHash = "sha256-VSyzdiPNcHDH/ebM2A0pTAyiMblMaJGEIULsIzupmaw=";

  meta = with lib; {
    description = "Realtime mapserver for minetest";
    mainProgram = "mapserver";
    homepage = "https://github.com/${pname}/mapserver/blob/master/readme.md";
    changelog = "https://github.com/${pname}/mapserver/releases/tag/v${version}";
    license = with licenses; [ mit cc-by-sa-30 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ gm6k ];
  };
}
