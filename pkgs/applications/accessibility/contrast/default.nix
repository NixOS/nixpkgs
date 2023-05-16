{ stdenv
, lib
, fetchFromGitLab
, cairo
, cargo
, desktop-file-utils
, gettext
, glib
, gtk4
, libadwaita
, meson
, ninja
, pango
, pkg-config
, rustPlatform
, rustc
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "contrast";
<<<<<<< HEAD
  version = "0.0.8";
=======
  version = "0.0.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "design";
    repo = "contrast";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-5OFmLsP+Xk3sKJcUG/s8KwedvfS8ri+JoinliyJSmrY=";
=======
    hash = "sha256-waoXv8dzqynkpfEPZSgZnS6fyo9+9+3Q2oy2fMtEsoE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
<<<<<<< HEAD
    hash = "sha256-8WukhoKMyApkwqPQ6KeWMsL40sMUcD4I4l7UqXf2Ld0=";
=======
    hash = "sha256-94QwPSiGjjPuskg5w6QfM5FuChFno7f9dh0Xr2wWKCI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    cargo
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    glib
    gtk4
    libadwaita
    pango
  ];

  meta = with lib; {
    description = "Checks whether the contrast between two colors meet the WCAG requirements";
    homepage = "https://gitlab.gnome.org/World/design/contrast";
    license = licenses.gpl3Plus;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ jtojnar ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.unix;
    # never built on aarch64-darwin, x86_64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin;
  };
}
