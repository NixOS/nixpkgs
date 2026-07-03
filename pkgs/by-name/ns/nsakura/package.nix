{
  lib,
  buildNimPackage,
  fetchFromGitHub,
}:
buildNimPackage rec {
  pname = "nsakura";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "KornelHajto";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/PAcHS0Yxhwp76FlyQXvBmlcSvaOsLtBEbgAKmmASIg=";
  };

  lockFile = ./lock.json;

  meta = with lib; {
    homepage = "https://github.com/KornelHajto/nsakura";
    description = "Terminal cherry blossom screensaver";
    license = lib.licenses.mit;
    mainProgram = "nsakura";
    maintainers = with lib.maintainers; [ yarn ];
    platforms = lib.platforms.all;
  };
}
