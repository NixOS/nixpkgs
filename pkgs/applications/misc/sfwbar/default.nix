{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk3,
  meson,
  ninja,
  json_c,
  pkg-config,
  gtk-layer-shell,
  libpulseaudio,
  libmpdclient,
  libxkbcommon,
}:
stdenv.mkDerivation rec {
  pname = "sfwbar";
  version = "v1.0_beta11";

  src = fetchFromGitHub {
    owner = "LBCrion";
    repo = pname;
    rev = version;
    sha256 = "PmpiO5gvurpaFpoq8bQdZ53FYSVDnyjN8MxDpelMnAU=";
  };

  nativeBuildInputs = [
    gtk3
    meson
    ninja
    pkg-config
    json_c
    gtk-layer-shell
    libpulseaudio
    libmpdclient
    libxkbcommon
  ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A flexible taskbar application for wayland compositors, designed with a stacking layout in mind";
    platforms = ["x86_64-linux"];
    maintainers = with maintainers; [NotAShelf];
    license = licenses.gpl3;
  };
}
