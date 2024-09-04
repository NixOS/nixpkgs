{
  appimageTools,
  lib,
  fetchurl,
}:
appimageTools.wrapType2 rec {
  pname = "httpie-desktop";
  version = "2024.1.2";

  src = fetchurl {
    url = "https://github.com/httpie/desktop/releases/download/v${version}/HTTPie-${version}.AppImage";
    sha256 = "sha256-OOP1l7J2BgO3nOPSipxfwfN/lOUsl80UzYMBosyBHrM=";
  };

  meta = with lib; {
    description = "Cross-platform API testing client for humans. Painlessly test REST, GraphQL, and HTTP APIs";
    homepage = "https://github.com/httpie/desktop";
    license = licenses.unfree;
    maintainers = with maintainers; [ luftmensch-luftmensch ];
    mainProgram = "httpie-desktop";
    platforms = [ "x86_64-linux" ];
  };
}
