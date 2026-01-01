{
  lib,
  stdenv,
  fetchFromGitHub,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
<<<<<<< HEAD
  vala,
  wrapGAppsHook4,
  cairo,
  discount,
  glib,
  gtk4,
  gtksourceview5,
  json-glib,
  libarchive,
  libgee,
  libwebp,
=======
  python3,
  shared-mime-info,
  vala,
  wrapGAppsHook3,
  cairo,
  discount,
  glib,
  gtk3,
  gtksourceview4,
  hicolor-icon-theme, # for setup-hook
  json-glib,
  libarchive,
  libgee,
  libhandy,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  libxml2,
  pantheon,
}:

stdenv.mkDerivation rec {
  pname = "minder";
<<<<<<< HEAD
  version = "2.0.3";
=======
  version = "1.17.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "phase1geo";
    repo = "minder";
<<<<<<< HEAD
    tag = version;
    hash = "sha256-gqTVRICPI6XlJmrBT6b5cONmBQ9LhsEuHUf/19NmXPo=";
=======
    rev = version;
    sha256 = "sha256-LZm2TLUugW/lSHp+y3Sz9IacQCEFQloVnZ9MoBjqHvI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
<<<<<<< HEAD
    vala
    wrapGAppsHook4
=======
    python3
    shared-mime-info
    vala
    wrapGAppsHook3
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  buildInputs = [
    cairo
    discount
    glib
<<<<<<< HEAD
    gtk4
    gtksourceview5
    json-glib
    libarchive
    libgee
    libwebp
    libxml2
    pantheon.granite7
  ];

=======
    gtk3
    gtksourceview4
    hicolor-icon-theme
    json-glib
    libarchive
    libgee
    libhandy
    libxml2
    pantheon.granite
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  postFixup = ''
    for x in $out/bin/*; do
      ln -vrs $x "$out/bin/''${x##*.}"
    done
  '';

<<<<<<< HEAD
  meta = {
    description = "Mind-mapping application for elementary OS";
    homepage = "https://github.com/phase1geo/Minder";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
=======
  meta = with lib; {
    description = "Mind-mapping application for elementary OS";
    homepage = "https://github.com/phase1geo/Minder";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "com.github.phase1geo.minder";
  };
}
