{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, rustPlatform
, cargo
, desktop-file-utils
<<<<<<< HEAD
, appstream-glib
, blueprint-compiler
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, meson
, ninja
, pkg-config
, rustc
, wrapGAppsHook
, python3
, git
, glib
, gtk4
, gst_all_1
, libadwaita
}:

stdenv.mkDerivation rec {
  pname = "solanum";
<<<<<<< HEAD
  version = "4.0.0";
=======
  version = "3.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Solanum";
<<<<<<< HEAD
    rev = version;
    hash = "sha256-ohUwxwhPxZlKoP5Nq/daD9z5Nj37C7MnFzyvQKp7R8E=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-eDwMBxMmj246tplZfREJkViCDbKmuWSUZyM+tChNQDA=";
=======
    rev = "v${version}";
    sha256 = "0cga6cz6jfbipzp008rjznkz7844licdc34lk133fcyqil0cg0ap";
  };

  patches = [
    # Fix build with meson 0.61, can be removed on next update
    # https://gitlab.gnome.org/World/Solanum/-/merge_requests/49
    (fetchpatch {
      url = "https://gitlab.gnome.org/World/Solanum/-/commit/e5c5d88f95b0fe4145c9ed346b8ca98a613d7cfe.patch";
      sha256 = "j84P9KzMr0o38u4OD4ZPst+yqw1LCRoa1awT3nelFDI=";
    })
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "10kzv98b2fiql9f6n2fv6lrgq4fdzxq0h4nzcq9jrw3fsggzl0wb";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    patchShebangs build-aux
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook
    python3
    git
    desktop-file-utils
<<<<<<< HEAD
    appstream-glib
    blueprint-compiler
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
  ];

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/World/Solanum";
    description = "A pomodoro timer for the GNOME desktop";
    maintainers = with maintainers; [ linsui ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
