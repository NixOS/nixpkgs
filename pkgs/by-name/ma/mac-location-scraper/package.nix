{
  lib,
  python2,
  fetchFromGitHub,
}:

python2.pkgs.buildPythonApplication {
  pname = "Mac-Locations-Scraper";
  version = "1.2";
  format = "other";

  src = fetchFromGitHub {
    owner = "mac4n6";
    repo = "Mac-Locations-Scraper";
    rev = "75ae3100a8361e1afec6f01efe50e04fa590b49a";
    hash = "sha256-QH3dxdhyaHsIUmWA4c7rglJDmeCDLfIWa7UH9yKy4BU=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp $src/mac_location_scraper.py $out/bin/mac-location-scraper
    chmod +x $out/bin/mac-location-scraper
  '';

  propagatedBuildInputs = [ python2.pkgs.simplekml ];

  meta = {
    description = "macOS/iOS database location scraper to extract location data";
    homepage = "https://github.com/mac4n6/Mac-Locations-Scraper";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mikehorn ];
    mainProgram = "mac-mocations-scraper";
  };
}
