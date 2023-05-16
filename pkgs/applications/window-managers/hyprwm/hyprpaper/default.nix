{ lib
, stdenv
, fetchFromGitHub
, cmake
<<<<<<< HEAD
, file
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, libjpeg
, mesa
, pango
, pkg-config
, wayland
, wayland-protocols
, wayland-scanner
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprpaper";
<<<<<<< HEAD
  version = "0.4.0";
=======
  version = "0.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-V5ulB9CkGh1ghiC4BKvRdoYKZzpaiOKzAOUmJIFkgM0=";
=======
    hash = "sha256-rAKfgQJQRsw4QMOXdxfHIh/d5LPY6HHKBX1KtaPs2No=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
<<<<<<< HEAD
    file
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    libjpeg
    mesa
    pango
    wayland
    wayland-protocols
  ];

  prePatch = ''
    substituteInPlace src/main.cpp \
      --replace GIT_COMMIT_HASH '"${finalAttrs.src.rev}"'
  '';

  preConfigure = ''
    make protocols
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 ./hyprpaper -t $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    inherit (finalAttrs.src.meta) homepage;
    description = "A blazing fast wayland wallpaper utility";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wozeparrot fufexan ];
    inherit (wayland.meta) platforms;
    broken = stdenv.isDarwin;
<<<<<<< HEAD
    mainProgram = "hyprpaper";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
})
