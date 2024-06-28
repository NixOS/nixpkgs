{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "minetest-mapserver";
  version = "4.9.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "mapserver";
    rev = "v${version}";
    hash = "sha256-bWaXHr0S7ud6LMo1OGmsrTIknKiLMbOBC5J8xse1hdo=";
  };

  vendorHash = "sha256-uz4HawbA7c802OEVFEI2I/fuE/TbPaK+ZY7B8Meiw+k=";

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
