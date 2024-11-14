{ stdenv
, lib
, fetchFromGitHub
, itstool
, meson
, ninja
, pkg-config
, wrapGAppsHook3
, gtk3
, gtksourceview
, gtkspell3
, webkitgtk_4_1
, pandoc
}:

stdenv.mkDerivation rec {
  pname = "marker";
  version = "2023.05.02";

  src = fetchFromGitHub {
    owner = "fabiocolacio";
    repo = "Marker";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-HhDhigQ6Aqo8R57Yrf1i69sM0feABB9El5R5OpzOyB0=";
  };

  nativeBuildInputs = [
    itstool
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    gtksourceview
    gtkspell3
    webkitgtk_4_1
    pandoc
  ];

  postPatch = ''
    meson rewrite kwargs set project / version '${version}'
  '';

  meta = with lib; {
    homepage = "https://fabiocolacio.github.io/Marker/";
    description = "Markdown editor for the Linux desktop made with GTK3";
    maintainers = with maintainers; [ trepetti aleksana ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    changelog = "https://github.com/fabiocolacio/Marker/releases/tag/${version}";
    mainProgram = "marker";
  };
}
