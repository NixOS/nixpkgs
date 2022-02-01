{ stdenv
, lib
, boehmgc
, boost
, cairo
, cmake
, fetchurl
, fetchpatch
, gettext
, ghostscript
, glib
, glibmm
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
, libsoup
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
, substituteAll
, wrapGAppsHook
, zlib
}:
let
  python3Env = python3.withPackages
    (ps: with ps; [
      numpy
      lxml
      pillow
      scour
    ]);
in
stdenv.mkDerivation rec {
  pname = "inkscape";
  version = "1.1.1";

  src = fetchurl {
    url = "https://media.inkscape.org/dl/resources/file/${pname}-${version}.tar.xz";
    sha256 = "sha256-rsoLnTO1sc+pqnBDO97mqMPQIP+vwubwyaYO7Xp5eK8=";
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
      python3 = "${python3Env}/bin/python";
    })

    # Fix parsing paths by Python extensions.
    # https://gitlab.com/inkscape/extensions/-/merge_requests/342
    (fetchpatch {
      url = "https://gitlab.com/inkscape/extensions/-/commit/a82c382c610d37837c8f3f5b13224bab8fd3667e.patch";
      sha256 = "YWrgjCnQ9q6BUsxSLQojIXnDzPxM/SgrIfj1gxQ/JKM=";
      stripLen = 1;
      extraPrefix = "share/extensions/";
    })

    # Fix build with Poppler 21.11.0.
    # https://gitlab.com/inkscape/inkscape/-/merge_requests/3622
    (fetchpatch {
      url = "https://gitlab.com/inkscape/inkscape/-/commit/5724c21b9cb7b6176a7b36ca24068b148c817e82.patch";
      sha256 = "/1p/Vkes1HuZN0v09Ey4kiT+4zrEaoSXyPAmc4O3sDg=";
    })

    # Remove mandatory break from end of paragraphs, added in Pango 1.49
    # https://gitlab.com/inkscape/inkscape/-/merge_requests/3630
    # TODO: Remove in Inkscape 1.1.2
    (fetchpatch {
      url = "https://gitlab.com/inkscape/inkscape/-/commit/b3dabef2245d4e4e977ee9d6776be9a134493515.patch";
      sha256 = "YhqUlRBKL1vJ/iCM/DvdwbmPIsAHQpcgf4TPpjlnBng=";
    })
    # Fix build against gcc-12
    # https://gitlab.com/inkscape/inkscape/-/merge_requests/3683
    (fetchpatch {
      name = "gcc-12.patch";
      url = "https://gitlab.com/inkscape/inkscape/-/commit/3825abc637ac2d3bc6ff997503b0631ac14e16b5.patch";
      sha256 = "sha256-VzKrWCkcVA1Co/xBTyh28Zhm2zFE/2jfZ3LveK0raO4=";
    })
  ];

  postPatch = ''
    patchShebangs share/extensions
    substituteInPlace share/extensions/eps_input.inx \
      --replace "location=\"path\">ps2pdf" "location=\"absolute\">${ghostscript}/bin/ps2pdf"
    substituteInPlace share/extensions/ps_input.inx \
      --replace "location=\"path\">ps2pdf" "location=\"absolute\">${ghostscript}/bin/ps2pdf"
    substituteInPlace share/extensions/ps_input.py \
      --replace "call('ps2pdf'" "call('${ghostscript}/bin/ps2pdf'"
    patchShebangs share/templates
    patchShebangs man/fix-roff-punct

    # double-conversion is a dependency of 2geom
    substituteInPlace CMakeScripts/DefineDependsandFlags.cmake \
      --replace 'find_package(DoubleConversion REQUIRED)' ""
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    python3Env
    glib # for setup hook
    gdk-pixbuf # for setup hook
    wrapGAppsHook
  ] ++ (with perlPackages; [
    perl
    XMLParser
  ]);

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
    libsoup
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
  ] ++ lib.optionals (!stdenv.isDarwin) [
    gspell
  ] ++ lib.optionals stdenv.isDarwin [
    cairo
    gtk-mac-integration
  ];

  # Make sure PyXML modules can be found at run-time.
  postInstall = lib.optionalString stdenv.isDarwin ''
    install_name_tool -change $out/lib/libinkscape_base.dylib $out/lib/inkscape/libinkscape_base.dylib $out/bin/inkscape
    install_name_tool -change $out/lib/libinkscape_base.dylib $out/lib/inkscape/libinkscape_base.dylib $out/bin/inkview
  '';

  meta = with lib; {
    description = "Vector graphics editor";
    homepage = "https://www.inkscape.org";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.jtojnar ];
    platforms = platforms.all;
    longDescription = ''
      Inkscape is a feature-rich vector graphics editor that edits
      files in the W3C SVG (Scalable Vector Graphics) file format.

      If you want to import .eps files install ps2edit.
    '';
  };
}
