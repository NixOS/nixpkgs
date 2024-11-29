{ lib
, fetchFromGitHub
, stdenv
, wayland-scanner
}:

stdenv.mkDerivation rec {
  pname = "cosmic-protocols";
  version = "0-unstable-2024-07-31";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "de2fead49d6af3a221db153642e4d7c2235aafc4";
    hash = "sha256-qgo8FMKo/uCbhUjfykRRN8KSavbyhZpu82M8npLcIPI=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  nativeBuildInputs = [ wayland-scanner ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-protocols";
    description = "Additional wayland-protocols used by the COSMIC desktop environment";
    license = [ licenses.mit licenses.gpl3Only ];
    maintainers = with maintainers; [ nyabinary ];
    platforms = platforms.linux;
  };
}
