{ lib
, cargo
, clang
, desktop-file-utils
, fetchFromGitLab
<<<<<<< HEAD
, glib
, gtk4
=======
, fetchpatch
, glib
, gtk4
, libclang
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, meson
, ninja
, pipewire
, pkg-config
, rustPlatform
, rustc
, stdenv
<<<<<<< HEAD
, wrapGAppsHook4
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "helvum";
<<<<<<< HEAD
  version = "0.4.1";
=======
  version = "0.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pipewire";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-nBU8dk22tzVf60yznTYJBYRKG+ctwWl1epU90R0zXr0=";
=======
    hash = "sha256-TvjO7fGobGmAltVHeXWyMtMLANdVWVGvBYq20JD3mMI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
<<<<<<< HEAD
    hash = "sha256-kzu8dzKob9KxKEP3ElUYCCTdyvbzi+jSXTaaaaPMhYg=";
=======
    hash = "sha256-W5Imlut30cjV4A6TCjBFLbViB0CDUucNsvIUiCXqu7I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    clang
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    rustPlatform.bindgenHook
<<<<<<< HEAD
    wrapGAppsHook4
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    desktop-file-utils
    glib
    gtk4
    pipewire
  ];

  meta = with lib; {
    description = "A GTK patchbay for pipewire";
    homepage = "https://gitlab.freedesktop.org/pipewire/helvum";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fufexan ];
    platforms = platforms.linux;
<<<<<<< HEAD
    mainProgram = "helvum";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
