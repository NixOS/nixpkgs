{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wayland-scanner
, wayfire
, wf-config
, alsa-lib
, gtkmm3
, gtk-layer-shell
, pulseaudio
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "wf-shell";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "WayfireWM";
<<<<<<< HEAD
    repo = "wf-shell";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-iQUBuNjbZuf51A69RC6NsMHFZCFRv+d9XZ0HtP6OpOA=";
=======
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-iQUBuNjbZuf51A69RC6NsMHFZCFRv+d9XZ0HtP6OpOA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayfire
    wf-config
    alsa-lib
    gtkmm3
    gtk-layer-shell
    pulseaudio
  ];

  mesonFlags = [ "--sysconfdir /etc" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/WayfireWM/wf-shell";
    description = "GTK3-based panel for Wayfire";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qyliss wucke13 rewine ];
    platforms = lib.platforms.unix;
  };
})
=======
  meta = with lib; {
    homepage = "https://github.com/WayfireWM/wf-shell";
    description = "GTK3-based panel for Wayfire";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss wucke13 rewine ];
    platforms = platforms.unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
