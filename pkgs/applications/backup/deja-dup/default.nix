{ stdenv
, fetchFromGitLab
, substituteAll
, meson
, ninja
, pkg-config
, vala
, gettext
, itstool
, glib
, gtk3
, coreutils
, libsoup
, libsecret
, libhandy_0
, wrapGAppsHook
, libgpgerror
, json-glib
, duplicity
}:

stdenv.mkDerivation rec {
  pname = "deja-dup";
  version = "42.4";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = pname;
    rev = version;
    sha256 = "c4E6mHYVb8TWVTVlmHidcLa9ebHJ27iStsNNLJhY8vY=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit coreutils;
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gettext
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    libsoup
    glib
    gtk3
    libsecret
    libhandy_0
    libgpgerror
    json-glib
  ];

  mesonFlags = [
    "-Dduplicity_command=${duplicity}/bin/duplicity"
  ];

  meta = with stdenv.lib; {
    description = "A simple backup tool";
    longDescription = ''
      Déjà Dup is a simple backup tool. It hides the complexity \
      of backing up the Right Way (encrypted, off-site, and regular) \
      and uses duplicity as the backend.
    '';
    homepage = "https://wiki.gnome.org/Apps/DejaDup";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
