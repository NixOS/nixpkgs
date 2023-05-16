{ stdenv
, lib
, rustPlatform
, fetchFromGitLab
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, cargo
, meson
, ninja
, gettext
<<<<<<< HEAD
, pkg-config
, rustc
, glib
, gtk4
, libadwaita
=======
, python3
, pkg-config
, rustc
, glib
, libhandy
, gtk3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, appstream-glib
, desktop-file-utils
, dbus
, openssl
, sqlite
, gst_all_1
<<<<<<< HEAD
, wrapGAppsHook4
=======
, wrapGAppsHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "gnome-podcasts";
<<<<<<< HEAD
  version = "0.6.0";
=======
  version = "0.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "podcasts";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-jnuy2UUPklfOYObSJPSqNhqqrfUP7N80pPmnw0rlB9A=";
  };

=======
    sha256 = "00vy1qkkpn76jdpybsq9qp8s6fh1ih10j73p2x43sl97m5g8944h";
  };

  patches = [
    # Fix build with meson 0.61, can be removed on next release.
    # podcasts-gtk/resources/meson.build:5:0: ERROR: Function does not take positional arguments.
    # podcasts-gtk/resources/meson.build:30:0: ERROR: Function does not take positional arguments.
    (fetchpatch {
      url = "https://gitlab.gnome.org/World/podcasts/-/commit/6614bb62ecbec7c3b18ea7fe44beb50fe7942b27.patch";
      sha256 = "3TVKFV9V6Ofdajgkdc+j+yxsU21C4JWSc6GjLExSM00=";
    })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "gettext-rs-0.4.2" = "sha256-wyZ1bf0oFcQo8gEi2GEalRUoKMoJYHysu79qcfjd4Ng=";
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
<<<<<<< HEAD
    cargo
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    gettext
=======
    gettext
    python3
    cargo
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook
    glib
  ];

  buildInputs = [
    appstream-glib
    desktop-file-utils
    glib
    gtk3
    libhandy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    dbus
    openssl
    sqlite
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-good
  ];

  # tests require network
  doCheck = false;

<<<<<<< HEAD
=======
  postPatch = ''
    chmod +x scripts/compile-gschema.py # patchShebangs requires executable file
    patchShebangs scripts/compile-gschema.py scripts/cargo.sh scripts/test.sh
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Listen to your favorite podcasts";
    homepage = "https://wiki.gnome.org/Apps/Podcasts";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/gnome-podcasts.x86_64-darwin
  };
}
