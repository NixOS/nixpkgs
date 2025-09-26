{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "materia-kde-theme";
  version = "20220823-unstable-2023-07-15";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = "materia-kde";
    rev = "6cc4c1867c78b62f01254f6e369ee71dce167a15";
    sha256 = "sha256-tZWEVq2VYIvsQyFyMp7VVU1INbO7qikpQs4mYwghAVM=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Port of the materia theme for Plasma";
    homepage = "https://github.com/PapirusDevelopmentTeam/materia-kde";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.diffumist ];
    platforms = platforms.all;
  };
}
