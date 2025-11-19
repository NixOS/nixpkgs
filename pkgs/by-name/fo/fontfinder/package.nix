{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook3,
  gdk-pixbuf,
  gtk3,
  libsoup_3,
  webkitgtk_4_1,
}:

stdenv.mkDerivation rec {
  pname = "fontfinder";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "mmstick";
    repo = "fontfinder";
    rev = version;
    hash = "sha256-C4KqEdqToVnPXFPWvNkl/md9L2W4NxRd5jvZ4E7CtfA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-g6PRGHrkHA0JTekKaQs+8mtyOCj99m0zPbgP8AnP7GU=";
  };

  nativeBuildInputs = [
    cargo
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook3
  ];

  buildInputs = [
    gdk-pixbuf
    gtk3
    libsoup_3
    webkitgtk_4_1
  ];

  makeFlags = [
    "prefix=$(out)"
  ];

  meta = with lib; {
    description = "GTK application for browsing and installing fonts from Google's font archive";
    homepage = "https://github.com/mmstick/fontfinder";
    changelog = "https://github.com/mmstick/fontfinder/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "fontfinder-gtk";
  };
}
