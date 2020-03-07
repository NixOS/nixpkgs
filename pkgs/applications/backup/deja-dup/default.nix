{ stdenv
, fetchFromGitLab
, substituteAll
, meson
, ninja
, pkgconfig
, vala
, gettext
, gnome3
, libnotify
, itstool
, glib
, gtk3
, libxml2
, gnome-online-accounts
, coreutils
, libsoup
, libsecret
, pcre
, libxkbcommon
, wrapGAppsHook
, libpthreadstubs
, libXdmcp
, epoxy
, at-spi2-core
, dbus
, libgpgerror
, json-glib
, appstream-glib
, desktop-file-utils
, duplicity
}:

stdenv.mkDerivation rec {
  pname = "deja-dup";
  version = "40.6";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = pname;
    rev = version;
    sha256 = "1d4g34g660wv42a4k2511bxrh90z0vdl3v7ahg0m45phijg9n2n1";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit coreutils;
    })

    # Hardcode GSettings path for Nautilus extension to avoid crashes from missing schemas
    ./hardcode-gsettings.patch
  ];

  postPatch = ''
    # substitute variable from hardcode-gsettings.patch
    substituteInPlace deja-dup/nautilus/NautilusExtension.c --subst-var-by DEJA_DUP_GSETTINGS_PATH "${glib.makeSchemaPath (placeholder "out") "${pname}-${version}"}"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    vala
    gettext
    itstool
    appstream-glib
    desktop-file-utils
    libxml2
    wrapGAppsHook
  ];

  buildInputs = [
    libnotify
    libsoup
    glib
    gtk3
    libsecret
    pcre
    libxkbcommon
    libpthreadstubs
    libXdmcp
    epoxy
    gnome3.nautilus
    at-spi2-core
    dbus
    gnome-online-accounts # GOA not used any more, only for transferring legacy keys
    libgpgerror
    json-glib
  ];

  # TODO: hard code the path
  # https://gitlab.gnome.org/World/deja-dup/merge_requests/32
  propagatedUserEnvPkgs = [ duplicity ];

  # install nautilus plug-in to correct path
  PKG_CONFIG_LIBNAUTILUS_EXTENSION_EXTENSIONDIR = "${placeholder "out"}/lib/nautilus/extensions-3.0";

  meta = with stdenv.lib; {
    description = "A simple backup tool";
    longDescription = ''
      Déjà Dup is a simple backup tool. It hides the complexity \
      of backing up the Right Way (encrypted, off-site, and regular) \
      and uses duplicity as the backend.
    '';
    homepage = "https://wiki.gnome.org/Apps/DejaDup";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jtojnar joncojonathan ];
    platforms = platforms.linux;
  };
}
