{ lib
, stdenv
, fetchFromGitHub
, gtk3
, meson
, ninja
, json_c
, pkg-config
, gtk-layer-shell
, libpulseaudio
, libmpdclient
, libxkbcommon
,
}:
stdenv.mkDerivation rec {
  pname = "sfwbar";
  version = "1.0_beta11";

  src = fetchFromGitHub {
    owner = "LBCrion";
    repo = pname;
    rev = "v${version}";
    sha256 = "PmpiO5gvurpaFpoq8bQdZ53FYSVDnyjN8MxDpelMnAU=";
  };

  buildInputs = [
    gtk3
    json_c
    gtk-layer-shell
    libpulseaudio
    libmpdclient
    libxkbcommon
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  meta = with lib; {
    homepage = "https://github.com/LBCrion/sfwbar";
    description = "A flexible taskbar application for wayland compositors, designed with a stacking layout in mind";
    platforms = platforms.linux;
    maintainers = with maintainers; [ NotAShelf ];
    license = licenses.gpl3Only;
  };
}
