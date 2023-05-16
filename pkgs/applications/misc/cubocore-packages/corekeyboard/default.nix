{ mkDerivation, lib, fetchFromGitLab, qtbase, qtx11extras, xorg, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "corekeyboard";
<<<<<<< HEAD
  version = "4.5.0";
=======
  version = "4.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Hylz1x9Wsk0iVhpNBFZJChsl3gIvJDICgpITjIXDZAg=";
=======
    sha256 = "sha256-zOH/w4QroMaVjWnFuWAJQ11RYlpXwIXRG9QYGDkfLVY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    qtx11extras
    xorg.libXtst
    xorg.libX11
    libcprime
    libcsys
  ];

  meta = with lib; {
    description = "A virtual keyboard for X11 from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/corekeyboard";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
