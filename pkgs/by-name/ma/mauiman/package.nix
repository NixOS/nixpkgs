{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  extra-cmake-modules,
  qt6,
  kdePackages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mauiman";
  version = "4.0.2";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "maui";
    repo = "mauiman";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1ia06/haUeb27p11EwDdJ/am5VDUzb9Up0/PgDplluQ=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    kdePackages.kdbusaddons
  ];

  cmakeFlags = [
    "-DBUILD_TESTING=OFF"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  meta = {
    description = "Maui manager library - server and library";
    homepage = "https://invent.kde.org/maui/mauiman";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sandwoodjones ];
  };
})
