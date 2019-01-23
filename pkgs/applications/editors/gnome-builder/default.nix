{ stdenv
, ctags
, desktop-file-utils
, docbook_xsl
, docbook_xml_dtd_43
, fetchurl
, flatpak
, glibcLocales
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
}:
let
  version = "3.30.3";
  pname = "gnome-builder";
in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "11h6apjyah91djf77m8xkl5rvdz7mwpp3bjc4yzzs9lm3pag764r";
  };

  nativeBuildInputs = [
    #appstream-glib # tests fail if these tools are available
    desktop-file-utils
    docbook_xsl
    docbook_xml_dtd_43
    glibcLocales # for Meson's gtkdochelper
    gobject-introspection
    gtk-doc
    hicolor-icon-theme
    meson
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
    libgit2-glib
    gnome3.libpeas
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

  outputs = [ "out" "devdoc" ];

  prePatch = ''
    patchShebangs build-aux/meson/post_install.py
  '';

  mesonFlags = [
    "-Dpython_libprefix=${python3.libPrefix}"
    "-Dwith_docs=true"

    # Making the build system correctly detect clang header and library paths
    # is difficult. Somebody should look into fixing this.
    "-Dwith_clang=false"
  ];

  # Some tests fail due to being unable to find the Vte typelib, and I don't
  # understand why. Somebody should look into fixing this.
  doCheck = false;

  preInstall = ''
    export LC_ALL="en_US.utf-8"
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
