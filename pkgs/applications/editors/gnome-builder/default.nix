{
  stdenv,
  lib,
  ctags,
  cmark,
  desktop-file-utils,
  editorconfig-core-c,
  fetchurl,
  flatpak,
  gnome,
  libgit2-glib,
  gi-docgen,
  gobject-introspection,
  enchant,
  icu,
  gtk4,
  gtksourceview5,
  json-glib,
  jsonrpc-glib,
  libadwaita,
  libdex,
  libpanel,
  libpeas2,
  libportal-gtk4,
  libsysprof-capture,
  libxml2,
  meson,
  ninja,
  ostree,
  d-spy,
  pcre2,
  pkg-config,
  python3,
  sysprof,
  template-glib,
  vala,
  vte-gtk4,
  webkitgtk_6_0,
  wrapGAppsHook4,
  dbus,
  xvfb-run,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-builder";
  version = "46.2";

  outputs = [
    "out"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-builder/${lib.versions.major finalAttrs.version}/gnome-builder-${finalAttrs.version}.tar.xz";
    hash = "sha256-DIV7iQA7JHh/Kx0qrhLSdaB0xmhLSIA7SMACdtk3GWM=";
  };

  patches = [
    # The test environment hardcodes `GI_TYPELIB_PATH` environment variable to direct dependencies of libide & co.
    # https://gitlab.gnome.org/GNOME/gnome-builder/-/commit/2ce510b0ec0518c29427a29b386bb2ac1a121edf
    # https://gitlab.gnome.org/GNOME/gnome-builder/-/commit/2964f7c2a0729f2f456cdca29a0f5b7525baf7c1
    #
    # But Nix does not have a fallback path for typelibs like /usr/lib on FHS distros and relies solely
    # on `GI_TYPELIB_PATH` environment variable. So, when Ide started to depend on Vte, which
    # depends on Pango, among others, GIrepository was unable to find these indirect dependencies
    # and crashed with:
    #
    #     Typelib file for namespace 'Pango', version '1.0' not found (g-irepository-error-quark, 0)
    ./fix-finding-test-typelibs.patch
  ];

  nativeBuildInputs = [
    desktop-file-utils
    gi-docgen
    gobject-introspection
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook4
  ];

  buildInputs = [
    ctags
    cmark
    editorconfig-core-c
    flatpak
    libgit2-glib
    libpeas2
    libportal-gtk4
    vte-gtk4
    enchant
    icu
    gtk4
    gtksourceview5
    json-glib
    jsonrpc-glib
    libadwaita
    libdex
    libpanel
    libsysprof-capture
    libxml2
    ostree
    d-spy
    pcre2
    python3
    template-glib
    vala
    webkitgtk_6_0
  ];

  nativeCheckInputs = [
    dbus
    xvfb-run
  ];

  mesonFlags = [
    "-Ddocs=true"

    # Making the build system correctly detect clang header and library paths
    # is difficult. Somebody should look into fixing this.
    "-Dplugin_clang=false"

    # Do not try to check if appstream images exist
    "-Dnetwork_tests=false"
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs build-aux/meson/post_install.py
    substituteInPlace build-aux/meson/post_install.py \
      --replace "gtk-update-icon-cache" "gtk4-update-icon-cache"
  '';

  checkPhase = ''
    GTK_A11Y=none \
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      meson test --print-errorlogs
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # For sysprof-agent
      --prefix PATH : "${sysprof}/bin"
    )

    # Ensure that all plugins get their interpreter paths fixed up.
    find $out/lib -name \*.py -type f -print0 | while read -d "" f; do
      chmod a+x "$f"
    done
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput share/doc/libide "$devdoc"
  '';

  passthru.updateScript = gnome.updateScript {
    packageName = "gnome-builder";
  };

  meta = with lib; {
    description = "An IDE for writing GNOME-based software";
    longDescription = ''
      Global search, auto-completion, source code map, documentation
      reference, and other features expected in an IDE, but with a focus
      on streamlining GNOME-based development projects.

      This package does not pull in the dependencies needed for every
      plugin. If you find that a plugin you wish to use doesn't work, we
      currently recommend running gnome-builder inside a nix-shell with
      appropriate dependencies loaded.
    '';
    homepage = "https://apps.gnome.org/Builder/";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
    mainProgram = "gnome-builder";
  };
})
