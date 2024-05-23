{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, cairo
, pkg-config
, rofi-unwrapped
}:

stdenv.mkDerivation {
  pname = "rofi-blezz";
  version = "2023-03-27";

  src = fetchFromGitHub {
    owner = "davatorium";
    repo = "rofi-blezz";
    rev = "3a00473471e7c56d2c349ad437937107b7d8e961";
    sha256 = "sha256-hY5UA7nyL6QoOBIZTjEiR0zjZFhkUkRa50r5rVZDnbg=";
  };

  patches = [
    ./0001-Patch-plugindir-to-output.patch
    ./0002-Patch-add-cairo.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
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
