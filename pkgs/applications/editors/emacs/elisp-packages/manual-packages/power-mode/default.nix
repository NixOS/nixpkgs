{ trivialBuild
, fetchFromGitHub
, emacs
}:

trivialBuild rec {
  pname = "power-mode";
  version = "0.pre+unstable=2021-06-06";

  src = fetchFromGitHub {
    owner = "elizagamedev";
    repo  = "power-mode.el";
    rev = "940e0aa36220f863e8f43840b4ed634b464fbdbb";
    hash = "sha256-Wy8o9QTWqvH9cP7xsTpF5QSd4mWNIPXJTadoADKeHWY=";
  };

  meta = {
    homepage = "https://github.com/elizagamedev/power-mode.el";
    description = "Imbue Emacs with power!";
    inherit (emacs.meta) platforms;
  };
}
