{ lib
, stdenv
, fetchFromGitHub
, wrapGAppsHook3
, desktop-file-utils
, glib
, gtk3
, json-glib
, libgee
, meson
, ninja
, pkg-config
, python3
, vala
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "remontoire";
  version = "unstable-2022-06-19";

  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "remontoire";
    rev = "68d562c78d6e0094ca744bd7161c308f583e93e";
    hash = "sha256-Cb6tzTGZdQA9oA04DO/xLBw5F+FRj5BM2Aa62YWGmZA=";
  };

  nativeBuildInputs = [
    glib
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook3
    desktop-file-utils
  ];

  buildInputs = [
    gtk3
    json-glib
    libgee
  ];

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py
  '';

  meta = with lib; {
    description = "Small GTK app for presenting keybinding hints";
    mainProgram = "remontoire";
    homepage = "https://github.com/regolith-linux/remontoire";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ aacebedo ];
  };
})
