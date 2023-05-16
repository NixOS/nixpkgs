{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
<<<<<<< HEAD
, wrapGAppsHook
, gtk3
, librsvg
=======
, gtk3
, gdk-pixbuf
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, withWayland ? false
, gtk-layer-shell
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "eww";
<<<<<<< HEAD
  version = "unstable-2023-08-18";

  src = fetchFromGitHub {
    owner = "elkowar";
    repo = "eww";
    rev = "a9a35c1804d72ef92e04ee71555bd9e5a08fa17e";
    hash = "sha256-GEysmNDm+olt1WXHzRwb4ZLifkXmeP5+APAN3b81/Og=";
  };

  cargoHash = "sha256-4yeu5AgleZMOLKNynGMd0XuyZxyyZ+RmzNtuJiNPN8g=";

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];

  buildInputs = [ gtk3 librsvg ] ++ lib.optional withWayland gtk-layer-shell;

  buildNoDefaultFeatures = true;
  buildFeatures = [
    (if withWayland then "wayland" else "x11")
  ];
=======
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "elkowar";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wzgWx3QxZvCAzRKLFmo/ru8hsIQsEDNeb4cPdlEyLxE=";
  };

  cargoSha256 = "sha256-9RfYDF31wFYylhZv53PJpZofyCdMiUiH/nhRB2Ni/Is=";

  cargoPatches = [ ./Cargo.lock.patch ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk3 gdk-pixbuf ] ++ lib.optional withWayland gtk-layer-shell;

  buildNoDefaultFeatures = withWayland;
  buildFeatures = lib.optional withWayland "wayland";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  cargoBuildFlags = [ "--bin" "eww" ];

  cargoTestFlags = cargoBuildFlags;

  # requires unstable rust features
  RUSTC_BOOTSTRAP = 1;

  meta = with lib; {
    description = "ElKowars wacky widgets";
    homepage = "https://github.com/elkowar/eww";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda lom ];
<<<<<<< HEAD
    mainProgram = "eww";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    broken = stdenv.isDarwin;
  };
}
