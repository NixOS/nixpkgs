{ lib
, stdenv
, fetchFromGitHub
, alsa-lib
, appstream-glib
, clang
, cmake
, desktop-file-utils
, glib
, gstreamer
, gtk4
, libadwaita
, libxml2
, meson
, ninja
, pkg-config
, poppler
, python3
, rustPlatform
, shared-mime-info
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "rnote";
  version = "0.5.16";

  src = fetchFromGitHub {
    owner = "flxzt";
    repo = "rnote";
    rev = "v${version}";
    hash = "sha256-blpANUfFam46Vyyc3vaB7vX07CRMtdMZR2n7FOLGgaU=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-vVU/OVwtIPRw1Ohe5EIqovhyd4oYOR7CPISz8Zo74r0=";
  };

  nativeBuildInputs = [
    appstream-glib # For appstream-util
    clang
    cmake
    desktop-file-utils # For update-desktop-database
    meson
    ninja
    pkg-config
    python3 # For the postinstall script
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
    shared-mime-info # For update-mime-database
    wrapGAppsHook4
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    alsa-lib
    glib
    gstreamer
    gtk4
    libadwaita
    libxml2
    poppler
  ];

  LIBCLANG_PATH = "${clang.cc.lib}/lib";

  postPatch = ''
    pushd build-aux
    chmod +x cargo_build.py meson_post_install.py
    patchShebangs cargo_build.py meson_post_install.py
    substituteInPlace meson_post_install.py --replace "gtk-update-icon-cache" "gtk4-update-icon-cache"
    popd
  '';

  meta = with lib; {
    homepage = "https://github.com/flxzt/rnote";
    changelog = "https://github.com/flxzt/rnote/releases/tag/${src.rev}";
    description = "Simple drawing application to create handwritten notes";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dotlambda yrd ];
    platforms = platforms.linux;
  };
}
