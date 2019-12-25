{ stdenv
, ctags
, appstream-glib
, desktop-file-utils
, docbook_xsl
, docbook_xml_dtd_43
, fetchurl
, fetchpatch
, flatpak
, gnome3
, libgit2-glib
, gobject-introspection
, gspell
, gtk-doc
, gtk3
, gtksourceview4
, json-glib
, jsonrpc-glib
, libdazzle
, libpeas
, libxml2
, meson
, ninja
, ostree
, pcre
, pcre2
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
, glib
}:

stdenv.mkDerivation rec {
  pname = "gnome-builder";
  version = "3.34.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "19018pq94cxf6fywd7fsmy98x56by5zfmh140pl530gaaw84cvhb";
  };

  patches = [
    # Fix build with Meson 0.52
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-builder/commit/c8b862b491cfbbb4f79b24d7cd90e4fb1f37cb9f.patch";
      sha256 = "0n8kg7nnjqmbnyag1ps6dvrlqrxc94djjncqx10d6y7ijwdxf4w8";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-builder/commit/da26dfbf78468f5ed724e022b300a07862a95833.patch";
      sha256 = "0psa65bzjpjj7vc5rknv2w2dz3p50jjv10s6j2fd6lpw8j2800k4";
    })
  ];

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    docbook_xsl
    docbook_xml_dtd_43
    gobject-introspection
    gtk-doc
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
    pcre2
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

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

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
