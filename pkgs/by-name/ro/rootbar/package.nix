{
  lib,
  gcc14Stdenv,
  fetchhg,
  pkg-config,
  meson,
  ninja,
  gtk3,
  json_c,
  libpulseaudio,
  wayland,
  wrapGAppsHook3,
}:

gcc14Stdenv.mkDerivation {
  pname = "rootbar";
  version = "unstable-2024-08-07";

  src = fetchhg {
    url = "https://hg.sr.ht/~scoopta/rootbar";
    rev = "36333af9fd8d";
    sha256 = "sha256-CpORCSJyHZhcK14EhjxoPt/h0026NU5J/kicL1dX96o=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    json_c
    libpulseaudio
    wayland
  ];

  meta = {
    homepage = "https://hg.sr.ht/~scoopta/rootbar";
    description = "Bar for wlroots-based Wayland compositors";
    mainProgram = "rootbar";
    longDescription = ''
      Root Bar is a bar for wlroots-based Wayland compositors such as Sway and
      was designed to address the lack of good bars for Wayland.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    broken = gcc14Stdenv.hostPlatform.isDarwin;
  };
}
