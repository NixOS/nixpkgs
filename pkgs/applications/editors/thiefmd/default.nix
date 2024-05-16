{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, vala
, pkg-config
, wrapGAppsHook3
, desktop-file-utils
, discount
, glib
, gtk3
, gtksourceview4
, gtkspell3
, json-glib
, libarchive
, libgee
, libhandy
, libsecret
, libxml2
, link-grammar
, webkitgtk_4_1
}:

stdenv.mkDerivation rec {
  pname = "thiefmd";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "kmwallio";
    repo = "ThiefMD";
    rev = "v${version}";
    hash = "sha256-noNfGFMeIyKhAgiovJDn91TLELAOQ4nD/5QlQfsKTII=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook3
    desktop-file-utils
  ];

  buildInputs = [
    discount # libmarkdown
    glib
    gtk3
    gtksourceview4
    gtkspell3
    json-glib
    libarchive
    libgee
    libhandy
    libsecret
    libxml2
    link-grammar
    webkitgtk_4_1
  ];

  meta = with lib; {
    description = "Markdown & Fountain editor that helps with organization and management";
    homepage = "https://thiefmd.com";
    downloadPage = "https://github.com/kmwallio/ThiefMD";
    mainProgram = "com.github.kmwallio.thiefmd";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
