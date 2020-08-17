{ stdenv
, lib
, fetchurl
, fetchFromGitLab
, substituteAll
, meson
, ninja
, pkg-config
, intltool
, babl
, gegl
, gtk3
, glib
, gdk-pixbuf
, graphviz
, isocodes
, pango
, cairo
, libarchive
, luajit
, freetype
, fontconfig
, lcms
, libpng
, libjpeg
, poppler
, poppler_data
, libtiff
, libmng
, librsvg
, libwmf
, zlib
, libzip
, ghostscript
, aalib
, shared-mime-info
, python3
, libexif
, gettext
, wrapGAppsHook
, libxslt
, gobject-introspection
, vala
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_45
, perl
, appstream-glib
, desktop-file-utils
, xorg
, glib-networking
, json-glib
, libmypaint
, gexiv2
, harfbuzz
, mypaint-brushes1
, libwebp
, libheif
, gjs
, libgudev
, openexr
, xvfb-run
, dbus
, gnome
, hicolor-icon-theme
, webkitgtk
, alsaLib
, AppKit
, Cocoa
, gtk-mac-integration-gtk3
}:

let
  python = python3.withPackages (pp: with pp; [ pygobject3 ]);
in stdenv.mkDerivation rec {
  pname = "gimp";
  version = "2.99.5-unstable-2021-03-11";

  outputs = [ "out" "dev" "devdoc" ];

  # src = fetchurl {
  #   url = "http://download.gimp.org/pub/gimp/v${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
  #   sha256 = "17lq6ns5qhspd171zqh76yf98xnn5n0hcl7hbhbx63cc6ribf6xx";
  # };

  # We should not use fetchFromGitLab because the build system
  # will complain and mark the build as unsupported when it cannot find
  # .git directory but downloading the whole repo is jus too much.
  src = fetchFromGitLab rec {
    name = "gimp-dev-${rev}"; # to make sure the hash is updated
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gimp";
    rev = "0ef5d672b7bd81b50e38f3cfb4bdce2df80f5458";
    sha256 = "u/vcjlVX+9OzlJodFPG2VKoLDWLPRaQJmOrpz3XlHkk=";
  };

  patches = [
    # to remove compiler from the runtime closure, reference was retained via
    # gimp --version --verbose output
    (substituteAll {
      src = ./remove-cc-reference.patch;
      cc_version = stdenv.cc.cc.name;
    })

    # Use absolute paths instead of relying on PATH
    # to make sure plug-ins are loaded by the correct interpreter.
    (substituteAll {
      src = ./hardcode-plugin-interpreters.patch;
      python_interpreter = python.interpreter;
    })

    # D-Bus configuration is not available in the build sandbox
    # so we need to pick up the one from the package.
    (substituteAll {
      src = ./tests-dbus-conf.patch;
      session_conf = "${dbus.daemon}/share/dbus-1/session.conf";
    })

    # Since we pass absolute datadirs to Meson, the path is resolved incorrectly.
    # What is more, even the assumption that iso-codes have the same datadir
    # subdirectory as GIMP is incorrect. Though, there is not a way to obtain
    # the correct directory at the moment. There is a MR against isocodes to fix that:
    # https://salsa.debian.org/iso-codes-team/iso-codes/merge_requests/11
    ./fix-isocodes-paths.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    intltool
    gettext
    wrapGAppsHook
    libxslt # for xsltproc
    gobject-introspection
    perl
    vala

    # for docs
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_45

    # for tests
    appstream-glib
    desktop-file-utils
    xvfb-run
    dbus
  ];

  buildInputs = [
    appstream-glib # for library
    babl
    gegl
    gtk3
    glib
    gdk-pixbuf
    pango
    cairo
    libarchive
    gexiv2
    harfbuzz
    isocodes
    freetype
    fontconfig
    lcms
    libpng
    libjpeg
    poppler
    poppler_data
    libtiff
    openexr
    libmng
    librsvg
    libwmf
    zlib
    libzip
    ghostscript
    aalib
    shared-mime-info
    json-glib
    libwebp
    libheif
    python
    libexif
    xorg.libXpm
    xorg.libXmu
    glib-networking
    libmypaint
    mypaint-brushes1
    webkitgtk

    # New file dialogue crashes with “Icon 'image-missing' not present in theme Symbolic” without an icon theme.
    gnome.adwaita-icon-theme

    # for Lua plug-ins
    (luajit.withPackages (pp: [
      pp.lgi
    ]))
  ] ++ lib.optionals (!stdenv.isDarwin) [
    alsaLib

    # for JavaScript plug-ins
    gjs
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
    Cocoa
    gtk-mac-integration-gtk3
  ] ++ lib.optionals stdenv.isLinux [
    libgudev
  ];

  # needed by gimp-2.0.pc
  propagatedBuildInputs = [
    gegl
  ];

  mesonFlags = [
    "-Dbug-report-url=https://github.com/NixOS/nixpkgs/issues/new"
    "-Dicc-directory=/run/current-system/sw/share/color/icc"
    "-Dcheck-update=false"
  ] ++ lib.optionals stdenv.isDarwin [
    "-Dalsa=disabled"
    "-Djavascript=false"
  ];

  # on Darwin,
  # test-eevl.c:64:36: error: initializer element is not a compile-time constant
  # on Linux, unable to find icons
  doCheck = false;

  # The check runs before glib-networking is registered
  GIO_EXTRA_MODULES = "${glib-networking}/lib/gio/modules";

  postPatch = ''
    patchShebangs \
      app/tests/create_test_env.sh \
      build/meson/run_test_env.sh \
      tools/defcheck.py \
      tools/extract-vector-icon.sh \
      tools/generate_changelog.sh \
      tools/generate-news \
      tools/gimppath2svg.py \
      tools/module-dependencies.py \
      tools/gimp-mkenums

    # Do not require network for appstream validation.
    substituteInPlace desktop/test-appdata.sh.in --replace 'validate-relax' 'validate-relax --nonet'
    substituteInPlace desktop/meson.build --replace "'validate-relax'" "'validate-relax', '--nonet'"

    # Bypass the need for downloading git archive.
    substitute app/git-version.h.in git-version.h \
      --subst-var-by GIMP_GIT_VERSION "GIMP_2.99.?-g${builtins.substring 0 10 src.rev}" \
      --subst-var-by GIMP_GIT_VERSION_ABBREV "${builtins.substring 0 10 src.rev}" \
      --subst-var-by GIMP_GIT_LAST_COMMIT_YEAR "${builtins.substring 9 4 version}"
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${lib.makeBinPath [
      # for dot for gegl:introspect (Debug » Show Image Graph, hidden by default on stable release)
      graphviz
    ]}")
  '';

  passthru = rec {
    # The declarations for `gimp-with-plugins` wrapper,
    # used for determining plug-in installation paths
    majorVersion = "2.99";
    targetLibDir = "lib/gimp/${majorVersion}";
    targetDataDir = "share/gimp/${majorVersion}";
    targetPluginDir = "${targetLibDir}/plug-ins";
    targetScriptDir = "${targetDataDir}/scripts";

    # probably its a good idea to use the same gtk in plugins ?
    gtk = gtk3;
  };

  meta = with lib; {
    description = "The GNU Image Manipulation Program";
    homepage = "https://www.gimp.org/";
    maintainers = with maintainers; [ jtojnar ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
