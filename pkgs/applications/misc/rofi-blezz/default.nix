{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, cairo
, pkg-config
, rofi-unwrapped
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "rofi-blezz";
  version = "unstable-2022-09-07";

  src = fetchFromGitHub {
    owner = "davatorium";
    repo = pname;
    rev = "b3183acd45fb7487a1e33fcbf07a47cb8da811c8";
    sha256 = "sha256-QA+V9aEcT3a9J8taPA/wRfXwMRdY69JKL0BYdsjPzmU=";
  };

  patches = [
    ./0001-Patch-plugindir-to-output.patch
    ./0002-Patch-add-cairo.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    cairo
    rofi-unwrapped
  ];

  meta = with lib; {
    description = "A plugin for rofi that emulates blezz behaviour";
    homepage = "https://github.com/davatorium/rofi-blezz";
    license = licenses.mit;
    maintainers = with maintainers; [ johnjohnstone ];
    platforms = platforms.linux;
  };
}
