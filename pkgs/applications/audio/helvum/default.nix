{ lib
, cargo
, clang
, desktop-file-utils
, fetchFromGitLab
, glib
, gtk4
, meson
, ninja
, pipewire
, pkg-config
, rustPlatform
, rustc
, stdenv
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "helvum";
  version = "0.4.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pipewire";
    repo = pname;
    rev = version;
    hash = "sha256-nBU8dk22tzVf60yznTYJBYRKG+ctwWl1epU90R0zXr0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-kzu8dzKob9KxKEP3ElUYCCTdyvbzi+jSXTaaaaPMhYg=";
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
    wrapGAppsHook4
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
    mainProgram = "helvum";
  };
}
