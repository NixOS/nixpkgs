{
  lib,
  fetchFromGitHub,
  stdenv,
  wayland-scanner,
}:

stdenv.mkDerivation rec {
  pname = "cosmic-protocols";
  version = "0-unstable-2024-01-11";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "e65fa5e2bb47e51656221657049bd3f88ae9dae5";
    hash = "sha256-vj7Wm1uJ5ULvGNEwKznNhujCZQiuntsWMyKQbIVaO/Q=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  nativeBuildInputs = [ wayland-scanner ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-protocols";
    description = "Addtional wayland-protocols used by the COSMIC desktop environment";
    license = [
      licenses.mit
      licenses.gpl3Only
    ];
    maintainers = with maintainers; [ nyanbinary ];
    platforms = platforms.linux;
  };
}
