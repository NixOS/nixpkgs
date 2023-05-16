{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wayland
, wrapGAppsHook
, wayfire
, wf-shell
, wf-config
, wayland-scanner
, wayland-protocols
, gtk3
, libevdev
, libxml2
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "wcm";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "WayfireWM";
<<<<<<< HEAD
    repo = "wcm";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-LJR9JGl49o4O6LARofz3jOeAqseGcmzVhMnhk/aobUU=";
=======
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-LJR9JGl49o4O6LARofz3jOeAqseGcmzVhMnhk/aobUU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    wrapGAppsHook
  ];

  buildInputs = [
    wayfire
    wf-config
    wf-shell
    wayland
    wayland-protocols
    gtk3
    libevdev
    libxml2
  ];

  mesonFlags = [
    "-Denable_wdisplays=false"
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/WayfireWM/wcm";
    description = "Wayfire Config Manager";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qyliss wucke13 rewine ];
    platforms = lib.platforms.unix;
    mainProgram = "wcm";
  };
})
=======
  meta = with lib; {
    homepage = "https://github.com/WayfireWM/wcm";
    description = "Wayfire Config Manager";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss wucke13 rewine ];
    platforms = platforms.unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
