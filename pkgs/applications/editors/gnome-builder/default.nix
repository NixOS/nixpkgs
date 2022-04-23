{ stdenv
, lib
, ctags
, cmark
, appstream-glib
, desktop-file-utils
, fetchurl
, flatpak
, gnome
, libgit2-glib
, gi-docgen
, gobject-introspection
, glade
, gspell
, gtk3
, gtksourceview4
, json-glib
, jsonrpc-glib
, libdazzle
, libhandy
, libpeas
, libportal-gtk3
, libxml2
, meson
, ninja
, ostree
, pcre
, pcre2
, pkg-config
, python3
, sysprof
, template-glib
, vala
, vte
, webkitgtk
, wrapGAppsHook
, dbus
, xvfb-run
}:

stdenv.mkDerivation rec {
  pname = "gnome-builder";
  version = "42.1";

  outputs = [ "out" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "XU1RtwKGW0gBcgHwxgfiSifXIDGo9ciNT86HW1VFZwo=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gi-docgen
    gobject-introspection
    meson
    ninja
    pkg-config
    python3
    python3.pkgs.wrapPython
    wrapGAppsHook
  ];

  buildInputs = [
    ctags
    cmark
    flatpak
    gnome.devhelp
    glade
    libgit2-glib
    libpeas
    libportal-gtk3
    vte
    gspell
    gtk3
    gtksourceview4
    json-glib
    jsonrpc-glib
    libdazzle
    libhandy
    libxml2
    ostree
    pcre
    pcre2
    python3
    sysprof
    template-glib
    vala
    webkitgtk
  ];

  checkInputs = [
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
  '';

  checkPhase = ''
    export NO_AT_BRIDGE=1
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test --print-errorlogs
  '';

  pythonPath = with python3.pkgs; requiredPythonModules [ pygobject3 ];

  preFixup = ''
    buildPythonPath "$out $pythonPath"
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$program_PYTHONPATH"
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
    packageName = pname;
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
    homepage = "https://wiki.gnome.org/Apps/Builder";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
