{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "minetest-mapserver";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "mapserver";
    rev = "v${version}";
    hash = "sha256-MKWC8m+7QN1gq+jmUqsadX+OKRF3/jVdoYTuaODCOtM=";
  };

  vendorHash = "sha256-q8l0wFXsR32dznB0oYiG9K/2+YQx6kOGtSSnznXLr5E=";

  meta = with lib; {
    description = "Realtime mapserver for minetest";
    mainProgram = "mapserver";
    homepage = "https://github.com/${pname}/mapserver/blob/master/readme.md";
    changelog = "https://github.com/${pname}/mapserver/releases/tag/v${version}";
    license = with licenses; [
      mit
      cc-by-sa-30
    ];
    platforms = platforms.all;
    maintainers = with maintainers; [ gm6k ];
  };
}
