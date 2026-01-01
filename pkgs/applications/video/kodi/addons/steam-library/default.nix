{
  lib,
  buildKodiAddon,
  fetchFromGitHub,
  requests,
  requests-cache,
  routing,
}:

buildKodiAddon rec {
  pname = "steam-library";
  namespace = "plugin.program.steam.library";
<<<<<<< HEAD
  version = "0.10.0";
=======
  version = "0.9.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "aanderse";
    repo = namespace;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-HwPNBqD+zS5sDNXtiGEmoc1RJ1SFCRzVOzUCjunMCnU=";
=======
    sha256 = "sha256-LVdFih0n/lkjyaYf8jw0IFlcDiXXOtUH2N9OduV1H9Q=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  propagatedBuildInputs = [
    requests
    requests-cache
    routing
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/aanderse/plugin.program.steam.library";
    description = "View your entire Steam library right from Kodi";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.kodi ];
=======
  meta = with lib; {
    homepage = "https://github.com/aanderse/plugin.program.steam.library";
    description = "View your entire Steam library right from Kodi";
    license = licenses.gpl3Plus;
    teams = [ teams.kodi ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
