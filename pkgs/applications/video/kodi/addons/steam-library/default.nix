{ lib, buildKodiAddon, fetchFromGitHub, requests, requests-cache, routing }:

buildKodiAddon rec {
  pname = "steam-library";
  namespace = "plugin.program.steam.library";
<<<<<<< HEAD
  version = "0.9.0";
=======
  version = "0.8.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "aanderse";
    repo = namespace;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-LVdFih0n/lkjyaYf8jw0IFlcDiXXOtUH2N9OduV1H9Q=";
=======
    sha256 = "1ai8k55bamzkx7awk3dl8ksw93pan3h9b1xlylcldy7a0ddldzdg";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    requests
    requests-cache
    routing
  ];

  meta = with lib; {
    homepage = "https://github.com/aanderse/plugin.program.steam.library";
    description = "View your entire Steam library right from Kodi";
    license = licenses.gpl3Plus;
    maintainers = teams.kodi.members;
  };
}
