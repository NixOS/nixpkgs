{ stdenv
, lib
, boehmgc
, boost
, cairo
, callPackage
, cmake
, desktopToDarwinBundle
, fetchurl
, fd
, gettext
, ghostscript
, glib
, glibmm
, gobject-introspection
, gsl
, gspell
, gtk-mac-integration
, gtkmm3
, gdk-pixbuf
, imagemagick
, lcms
, lib2geom
, libcdr
, libexif
, libpng
, librevenge
, librsvg
, libsigcxx
, libvisio
, libwpg
, libXft
, libxml2
, libxslt
, ninja
, perlPackages
, pkg-config
, poppler
, popt
, potrace
, python3
, runCommand
, substituteAll
, wrapGAppsHook3
, libepoxy
, zlib
, yq
}:
let
  python3Env = python3.withPackages
    (ps: with ps; [
      # List taken almost verbatim from the output of nix-build -A inkscape.passthru.pythonDependencies
      appdirs
      beautifulsoup4
      cachecontrol
      cssselect
      filelock
      inkex
      lxml
      numpy
      packaging
      pillow
      pygobject3
      pyparsing
      pyserial
      requests
      scour
      tinycss2
      zstandard
    ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "inkscape";
  version = "1.4";

  src = fetchurl {
    url = "https://inkscape.org/release/inkscape-${finalAttrs.version}/source/archive/xz/dl/inkscape-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-xZqFRTtpmt3rzVHB3AdoTdlqEMiuxxaxlVHbUFYuE/U=";
  };

  # Inkscape hits the ARGMAX when linking on macOS. It appears to be
  # CMake’s ARGMAX check doesn’t offer enough padding for NIX_LDFLAGS.
  # Setting strictDeps it avoids duplicating some dependencies so it
  # will leave us under ARGMAX.
  strictDeps = true;

  patches = [
    (substituteAll {
      src = ./fix-python-paths.patch;
      # Python is used at run-time to execute scripts,
      # e.g., those from the "Effects" menu.
      python3 = lib.getExe python3Env;
    })
    (substituteAll {
      # Fix path to ps2pdf binary
      src = ./fix-ps2pdf-path.patch;
      inherit ghostscript;
    })
  ];

  postPatch = ''
    patchShebangs share/extensions
    patchShebangs share/templates
    patchShebangs man/fix-roff-punct

    # double-conversion is a dependency of 2geom
    substituteInPlace CMakeScripts/DefineDependsandFlags.cmake \
      --replace-fail 'find_package(DoubleConversion REQUIRED)' ""
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    python3Env
    glib # for setup hook
    gdk-pixbuf # for setup hook
    wrapGAppsHook3
    gobject-introspection
  ] ++ (with perlPackages; [
    perl
    XMLParser
  ]) ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
  ];

  buildInputs = [
    boehmgc
    boost
    gettext
    glib
    glibmm
    gsl
    gtkmm3
    imagemagick
    lcms
    lib2geom
    libcdr
    libexif
    libpng
    librevenge
    librsvg # for loading icons
    libsigcxx
    libvisio
    libwpg
    libXft
    libxml2
    libxslt
    perlPackages.perl
    poppler
    popt
    potrace
    python3Env
    zlib
    libepoxy
  ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    gspell
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cairo
    gtk-mac-integration
  ];

  # Make sure PyXML modules can be found at run-time.
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    for f in $out/lib/inkscape/*.dylib; do
      ln -s $f $out/lib/$(basename $f)
    done
  '';

  passthru = {
    tests = {
      ps2pdf-plugin = callPackage ./test-ps2pdf-plugin.nix { };
      inherit (python3.pkgs) inkex;
    };

    pythonDependencies = runCommand "python-dependency-list" {
      nativeBuildInputs = [
        fd
        yq
      ];
      inherit (finalAttrs) src;
    } ''
      unpackPhase
      tomlq --slurp 'map(.tool.poetry.dependencies | to_entries | map(.key)) | flatten | map(ascii_downcase) | unique' $(fd pyproject.toml) > "$out"
    '';
  };

  meta = {
    description = "Vector graphics editor";
    homepage = "https://www.inkscape.org";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      jtojnar
      x123
      Luflosi
    ];
    platforms = lib.platforms.all;
    mainProgram = "inkscape";
    longDescription = ''
      Inkscape is a feature-rich vector graphics editor that edits
      files in the W3C SVG (Scalable Vector Graphics) file format.

      If you want to import .eps files install ps2edit.
    '';
  };
})
