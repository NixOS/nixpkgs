{ lib, buildKodiAddon, fetchFromGitHub, addonUpdateScript, kodi-six, signals }:

buildKodiAddon rec {
  pname = "youtube-dl";
  namespace = "script.module.youtube.dl";
  version = "23.910.0";

  src = fetchFromGitHub {
    owner = "Catch-up-TV-and-More";
    repo = "script.module.youtube.dl";
    rev = "b07df66d4da918ef13730deb09fb02376d00b46a";
    hash = "sha256-e3JUsyu3NB0DsOsEMy5fJ+VZVb+YIOMf8320AGv5Wno=";
  };

  propagatedBuildInputs = [ signals kodi-six ];

  passthru = {
    pythonPath = "lib";
  };

  meta = with lib; {
    homepage =
      "https://github.com/Catch-up-TV-and-More/script.module.youtube.dl";
    description = "Access to youtube-dl stream extraction in an XBMC module";
    license = licenses.gpl2;
    maintainers = teams.kodi.members;
  };
}
