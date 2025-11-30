{
  lib,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
  pango,
  gdk-pixbuf,
  atk,
  gtk3,
}:

rustPlatform.buildRustPackage rec {
  pname = "niri-taskbar";
  version = "0.3.0+niri.25.08";

  src = fetchFromGitHub {
    owner = "lawngnome";
    repo = "niri-taskbar";
    rev = "v${version}";
    hash = "sha256-Gbzh4OTkvtP9F/bfDUyA14NH2DMDdr3i6oFoFwinEAg=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    pango
    gdk-pixbuf
    atk
    gtk3
  ];

  meta = {
    description = "A taskbar for the niri compositor";
    homepage = "https://github.com/lawngnome/niri-taskbar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luochen1990 ];
    mainProgram = "niri-taskbar";
  };
}
