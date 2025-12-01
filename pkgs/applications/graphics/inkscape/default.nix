{
  stdenv,
  lib,
  boehmgc,
  boost,
  cairo,
  callPackage,
  cmake,
  desktopToDarwinBundle,
  fetchpatch,
  fetchurl,
  fd,
  gettext,
  ghostscript,
  glib,
  glibmm,
  gobject-introspection,
  gsl,
  gspell,
  gtk-mac-integration,
  gtkmm3,
  gdk-pixbuf,
  imagemagick,
  lcms,
  lib2geom,
  libcdr,
  libexif,
  libpng,
  librevenge,
  librsvg,
  libsigcxx,
  libvisio,
  libwpg,
  libXft,
  libxml2,
  libxslt,
  ninja,
  perlPackages,
  pkg-config,
  poppler,
  popt,
  potrace,
  python3,
  runCommand,
  replaceVars,
  wrapGAppsHook3,
  libepoxy,
  zlib,
  yq,
}:
let
  python3Env = python3.withPackages (
    ps: with ps; [
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
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "inkscape";
  version = "1.4.2";
  outputs = [
    "out"
    "man"
  ];

  src = fetchurl {
    url = "https://inkscape.org/release/inkscape-${finalAttrs.version}/source/archive/xz/dl/inkscape-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-IABTDHkX5SYMnoV1pxVP9pJmQ9IAZIfXFOMEqWPwx4I=";
  };

  # Inkscape hits the ARGMAX when linking on macOS. It appears to be
  # CMake’s ARGMAX check doesn’t offer enough padding for NIX_LDFLAGS.
  # Setting strictDeps it avoids duplicating some dependencies so it
  # will leave us under ARGMAX.
  strictDeps = true;

  patches = [
    (replaceVars ./fix-python-paths.patch {
      # Python is used at run-time to execute scripts,
      # e.g., those from the "Effects" menu.
      python3 = lib.getExe python3Env;
    })
    (replaceVars ./fix-ps2pdf-path.patch {
      # Fix path to ps2pdf binary
      inherit ghostscript;
    })
    (fetchpatch {
      name = "fix-build-poppler-25.06.0.patch";
      url = "https://gitlab.com/inkscape/inkscape/-/commit/40f5b15b7e29908b79c54e81db6f340936102e08.patch";
      hash = "sha256-bYRd/KUh/7qFb7x0EuUgQYA9P8abcTf5XS67gzaAiXA=";
    })
    (fetchpatch {
      name = "fix-build-poppler-25.07.0.patch";
      url = "https://gitlab.com/inkscape/inkscape/-/commit/8ae83ca81bbaebcc0ff0abe82300d56d2c94e6f9.patch";
      hash = "sha256-s7UMnv1pAiQA/HL5CEdBwCn4v/tsphc0MSnBJAoqolY=";
    })
    (fetchpatch {
      name = "fix-build-poppler-25.09.0.patch";
      url = "https://gitlab.com/inkscape/inkscape/-/commit/f48b429827dca510b41a5671d467e574ef348625.patch";
      hash = "sha256-9CfmkTGMVHjZiiE3zvi4YOrytcir8a7O2z3PrhjcohI=";
    })
    (fetchpatch {
      name = "fix-build-poppler-25.10.0.patch";
      url = "https://gitlab.com/inkscape/inkscape/-/commit/4dba481fe898c6317696d50b109f5aed8f269c19.patch";
      hash = "sha256-FFCkMU+Ec2qobG4ru89NPcM9Gxw8ZyFV+6jpW8ZwgE4=";
    })
  ];

  postPatch = ''
    patchShebangs share/extensions
    patchShebangs share/templates
    patchShebangs man/fix-roff-punct

    # double-conversion is a dependency of 2geom
    substituteInPlace CMakeScripts/DefineDependsandFlags.cmake \
      --replace-fail 'find_package(DoubleConversion REQUIRED)' ""
    # use native Python when cross-compiling
    shopt -s globstar
    for f in **/CMakeLists.txt; do
      substituteInPlace $f \
        --replace-quiet "COMMAND python3" "COMMAND ${lib.getExe python3Env.pythonOnBuildForHost}"
    done
    shopt -u globstar
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
  ]
  ++ (with perlPackages; [
    perl
    XMLParser
  ])
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    gspell
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
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

    pythonDependencies =
      runCommand "python-dependency-list"
        {
          nativeBuildInputs = [
            fd
            yq
          ];
          inherit (finalAttrs) src;
        }
        ''
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
