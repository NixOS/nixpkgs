{ gcc8Stdenv
, ctags
, appstream-glib
, desktop-file-utils
, docbook_xsl
, docbook_xml_dtd_43
, fetchurl
, flatpak
, gnome3
, libgit2-glib
, gobject-introspection
, gspell
, gtk-doc
, gtk3
, gtksourceview4
, hicolor-icon-theme
, json-glib
, jsonrpc-glib
, libdazzle
, libpeas
, libxml2
, meson
, ninja
, ostree
, pcre
, pkgconfig
, python3
, sysprof
, template-glib
, vala
, vte
, webkitgtk
, wrapGAppsHook
, dbus
, xvfb_run
}:

let
  # Does not build with GCC 7
  # https://gitlab.gnome.org/GNOME/gnome-builder/issues/868
  stdenv = gcc8Stdenv;
in
stdenv.mkDerivation rec {
  pname = "gnome-builder";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "00l7sshpndk995aw98mjmsc3mxhxzynlp7il551iwwjjdbc70qp4";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    docbook_xsl
    docbook_xml_dtd_43
    gobject-introspection
    gtk-doc
    hicolor-icon-theme
    (meson.override ({ inherit stdenv; }))
    ninja
    pkgconfig
    python3
    python3.pkgs.wrapPython
    wrapGAppsHook
  ];

  buildInputs = [
    ctags
    flatpak
    gnome3.devhelp
    gnome3.glade
    libgit2-glib
    libpeas
    vte
    gspell
    gtk3
    gtksourceview4
    json-glib
    jsonrpc-glib
    libdazzle
    libxml2
    ostree
    pcre
    python3
    sysprof
    template-glib
    vala
    webkitgtk
  ];

  checkInputs = [
    dbus
    xvfb_run
  ];

  outputs = [ "out" "devdoc" ];

  prePatch = ''
    patchShebangs build-aux/meson/post_install.py
  '';

  mesonFlags = [
    "-Dpython_libprefix=${python3.libPrefix}"
    "-Ddocs=true"

    # Making the build system correctly detect clang header and library paths
    # is difficult. Somebody should look into fixing this.
    "-Dplugin_clang=false"

    # Do not try to check if appstream images exist
    "-Dnetwork_tests=false"
  ];

  # Some tests fail due to being unable to find the Vte typelib, and I don't
  # understand why. Somebody should look into fixing this.
  doCheck = true;

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

  passthru.updateScript = gnome3.updateScript { packageName = pname; };

  meta = with stdenv.lib; {
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
    homepage = https://wiki.gnome.org/Apps/Builder;
    license = licenses.gpl3Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
