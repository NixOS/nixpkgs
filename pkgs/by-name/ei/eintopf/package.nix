{ lib
, buildGoModule
, fetchFromGitea
}:

buildGoModule rec {
  pname = "eintopf";
  version = "0-unstable-2024-02-20";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Klasse-Methode";
    repo = "eintopf";
    rev = "79b12d06681f5e8bd614195d2374ea04d7780b1f";
    hash = "sha256-BxakSdrGGz3v5HNXQtdEroyaiWCs7pXyAq+tnYXtGOw=";
  };

  vendorHash = "sha256-dBxI6cUGc16lg89x8b+hSLcv5y/MLf6vDIvqdMBUz3I=";

  meta = with lib; {
    description = "A calendar for Stuttgart, showing events, groups and places";
    homepage = "https://codeberg.org/Klasse-Methode/eintopf";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.unix;
  };
}

