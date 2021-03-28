{ lib, stdenv
, fetchhg
, pkg-config
, meson
, ninja
, gtk3
, json_c
, libpulseaudio
, wayland
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "rootbar";
  version = "unstable-2020-11-13";

  src = fetchhg {
    url = "https://hg.sr.ht/~scoopta/rootbar";
    rev = "a018e10cfc5e";
    sha256 = "sha256-t6oDIYCVaCxaYy4bS1vxESaFDNxsx5JQLQK77eVuafE=";
  };

  nativeBuildInputs = [
    meson ninja pkg-config wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    json_c
    libpulseaudio
    wayland
  ];

  meta = with lib; {
    homepage = "https://github.com/alexays/waybar";
    description = "A bar for Wayland WMs";
    longDescription = ''
      Root Bar is a bar for wlroots based wayland compositors such as sway and
      was designed to address the lack of good bars for wayland.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
