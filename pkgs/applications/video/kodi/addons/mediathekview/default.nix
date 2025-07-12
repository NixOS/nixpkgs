{
  lib,
  buildKodiAddon,
  fetchFromGitHub,
  myconnpy,
}:

buildKodiAddon rec {
  pname = "mediathekview";
  namespace = "plugin.video.mediathekview";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = pname;
    repo = namespace;
    rev = "release-${version}";
    hash = "sha256-XYyocXFTiYO7Ar0TtxjpCAy2Ywtnwb8BTxdKxwDWm4Y=";
  };

  propagatedBuildInputs = [
    myconnpy
  ];

  meta = with lib; {
    homepage = "https://github.com/mediathekview/plugin.video.mediathekview";
    description = "Access media libraries of German speaking broadcasting stations";
    license = licenses.mit;
    teams = [ teams.kodi ];
  };
}
