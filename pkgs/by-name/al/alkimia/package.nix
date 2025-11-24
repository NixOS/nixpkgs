{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  doxygen,
  graphviz,
  mpir,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "alkimia";
  version = "8.2.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "office";
    repo = "alkimia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v5DfnnzOMsoCXr074ydXxBIrSsnbex6G/OqF6psTvPs=";
  };

  cmakeFlags = [
    "-DBUILD_WITH_QT6=1"
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
  ]
  ++ (with kdePackages; [
    extra-cmake-modules
    wrapQtAppsHook
  ]);

  # qtwebengine is not a mandatory dependency, but it adds some features
  # we might need for alkimia's dependents. See:
  # https://github.com/KDE/alkimia/blob/v8.1.2/CMakeLists.txt#L124
  buildInputs = with kdePackages; [
    qtbase
    qtwebengine
    libplasma
    knewstuff
    kpackage
  ];

  propagatedBuildInputs = [ mpir ];

  meta = {
    description = "Library used by KDE finance applications";
    mainProgram = "onlinequoteseditor5";
    longDescription = ''
      Alkimia is the infrastructure for common storage and business
      logic that will be used by all financial applications in KDE.

      The target is to share financial related information over
      application boundaries.
    '';
    license = lib.licenses.lgpl21Plus;
    platforms = kdePackages.qtbase.meta.platforms;
  };
})
