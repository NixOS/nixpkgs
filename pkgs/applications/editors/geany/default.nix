{
  lib,
  stdenv,
  fetchurl,
  gtk3,
  which,
  pkg-config,
  intltool,
  file,
  libintl,
  hicolor-icon-theme,
  python3,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "geany";
  version = "2.0";

  outputs = [
    "out"
    "dev"
    "doc"
    "man"
  ];

  src = fetchurl {
    url = "https://download.geany.org/geany-${finalAttrs.version}.tar.bz2";
    hash = "sha256-VltM0vAxHB46Fn7HHEoy26ZC4P5VSuW7a4F3t6dMzJI=";
  };

  patches = [
    # The test runs into UB in headless environments and crashes at least on headless Darwin.
    # Remove if https://github.com/geany/geany/pull/3676 is merged (or the issue fixed otherwise).
    ./disable-test-sidebar.patch
  ];

  nativeBuildInputs = [
    pkg-config
    intltool
    libintl
    which
    file
    hicolor-icon-theme
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
  ];

  preCheck = ''
    patchShebangs --build tests/ctags/runner.sh
    patchShebangs --build scripts
  '';

  doCheck = true;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Small and lightweight IDE";
    longDescription = ''
      Geany is a small and lightweight Integrated Development Environment.
      It was developed to provide a small and fast IDE, which has only a few dependencies from other packages.
      Another goal was to be as independent as possible from a special Desktop Environment like KDE or GNOME.
      Geany only requires the GTK runtime libraries.
      Some basic features of Geany:
      - Syntax highlighting
      - Code folding
      - Symbol name auto-completion
      - Construct completion/snippets
      - Auto-closing of XML and HTML tags
      - Call tips
      - Many supported filetypes including C, Java, PHP, HTML, Python, Perl, Pascal (full list)
      - Symbol lists
      - Code navigation
      - Build system to compile and execute your code
      - Simple project management
      - Plugin interface
    '';
    homepage = "https://www.geany.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ frlan ];
    platforms = platforms.all;
    mainProgram = "geany";
  };
})
