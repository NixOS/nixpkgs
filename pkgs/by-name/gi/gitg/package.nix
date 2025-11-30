{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  vala,
  pkg-config,
  gtk3,
  glib,
  gpgme,
  json-glib,
  wrapGAppsHook3,
  libpeas,
  bash,
  gobject-introspection,
  gtksourceview4,
  gsettings-desktop-schemas,
  gnome,
  gspell,
  gvfs,
  shared-mime-info,
  libgee,
  libgit2-glib,
  libhandy,
  libsecret,
  libxml2,
  meson,
  ninja,
  python3,
  libdazzle,
}:

stdenv.mkDerivation rec {
  pname = "gitg";
  version = "44";

  src = fetchurl {
    url = "mirror://gnome/sources/gitg/${lib.versions.majorMinor version}/gitg-${version}.tar.xz";
    hash = "sha256-NCoxaE2rlnHNNBvT485mWtzuBGDCoIHdxJPNvAMTJTA=";
  };

  patches = [
    # Switch to girepository-2.0
    # https://gitlab.gnome.org/GNOME/gitg/-/merge_requests/278
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/gitg/raw/630cf1bdb50ad37fb20b81d76caa8622e7225c58/f/gitg-gir-2.0.patch";
      hash = "sha256-9pC7wrxWcI1C/8yB5AcaED0RyaVbQzT0Ajuz0TM4hmo=";
    })
  ];

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gpgme
    gsettings-desktop-schemas
    gtk3
    gtksourceview4
    gspell
    gvfs
    json-glib
    libdazzle
    libgee
    libgit2-glib
    libhandy
    libpeas
    libsecret
    libxml2
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs meson_post_install.py

    substituteInPlace tests/libgitg/test-commit.vala --replace-fail "/bin/bash" "${bash}/bin/bash"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gitg";
    };
  };

  strictDeps = true;

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gitg";
    changelog = "https://gitlab.gnome.org/GNOME/gitg/-/blob/v${version}/NEWS?ref_type=tags";
    description = "GNOME GUI client to view git repositories";
    mainProgram = "gitg";
    maintainers = with lib.maintainers; [
      Luflosi
    ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
