{ lib
, stdenv
, fetchFromGitHub
, vala
, meson
, ninja
, python3
, pkg-config
, wrapGAppsHook4
, desktop-file-utils
, gtk4
, libadwaita
, json-glib
, glib
, glib-networking
<<<<<<< HEAD
, gobject-introspection
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, gtksourceview5
, libxml2
, libgee
, libsoup_3
, libsecret
<<<<<<< HEAD
, libwebp
, libspelling
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, gst_all_1
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "tuba";
<<<<<<< HEAD
  version = "0.4.1";
=======
  version = "0.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "GeopJr";
    repo = "Tuba";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-1XbgsdIcnlXJtNEzDgEfHVJHF9naz3HplCPc2cKFUWw=";
=======
    hash = "sha256-LPhGGIHvN/hc71PL50TBw1Q0ysubdtJaEiUEI29HRrE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    python3
    wrapGAppsHook4
    desktop-file-utils
<<<<<<< HEAD
    gobject-introspection
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    glib
    glib-networking
    gtksourceview5
    json-glib
    libxml2
    libgee
    libsoup_3
    gtk4
    libadwaita
    libsecret
<<<<<<< HEAD
    libwebp
    libspelling
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ (with gst_all_1; [
    gstreamer
    gst-libav
    gst-plugins-base
    (gst-plugins-good.override { gtkSupport = true; })
    gst-plugins-bad
  ]);

  passthru = {
<<<<<<< HEAD
    updateScript = nix-update-script { };
=======
    updateScript = nix-update-script {
      attrPath = "tuba";
    };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = with lib; {
    description = "Browse the Fediverse";
    homepage = "https://tuba.geopjr.dev/";
    mainProgram = "dev.geopjr.Tuba";
    license = licenses.gpl3Only;
    changelog = "https://github.com/GeopJr/Tuba/releases/tag/v${version}";
<<<<<<< HEAD
    maintainers = with maintainers; [ chuangzhu aleksana ];
=======
    maintainers = with maintainers; [ chuangzhu ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
