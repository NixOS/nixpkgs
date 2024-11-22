{
  lib,
  mkDerivation,
  cmake,
  extra-cmake-modules,
  applet-window-buttons,
  karchive,
  kcoreaddons,
  ki18n,
  kio,
  kirigami2,
  mauikit,
  mauikit-filebrowsing,
  mauikit-imagetools,
  qtmultimedia,
  qtquickcontrols2,
  qtlocation,
  exiv2,
  kquickimageedit,
  fetchFromGitHub,
}:

let
  src-kdtree = fetchFromGitHub {
    owner = "cdalitz";
    repo = "kdtree-cpp";
    rev = "refs/tags/v1.3";
    hash = "sha256-h3cmndvjMlp/MTk/Ve3R183BLrE7VbL7GQx8YkOHEgU=";
  };
in
mkDerivation {
  pname = "pix";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  postPatch = ''
    cp ${src-kdtree}/kdtree.cpp src/
    substituteInPlace src/CMakeLists.txt \
      --replace-fail "main.cpp" "main.cpp kdtree.cpp"
  '';

  env = {
    NIX_CFLAGS_COMPILE = toString [
      "-I${src-kdtree}"
    ];
  };

  buildInputs = [
    applet-window-buttons
    karchive
    kcoreaddons
    ki18n
    kio
    kirigami2
    mauikit
    mauikit-filebrowsing
    mauikit-imagetools
    qtmultimedia
    qtquickcontrols2
    qtlocation
    exiv2
    kquickimageedit
  ];

  meta = {
    description = "Image gallery application";
    mainProgram = "pix";
    homepage = "https://invent.kde.org/maui/pix";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ onny ];
  };
}
