{ stdenv
, lib
, fetchFromGitHub
, cmake
, extra-cmake-modules
, wrapGAppsHook
, qt5
, libsForQt5
}:

stdenv.mkDerivation rec {
  pname = "ClipboardInspector";
  version = "1.0.0-beta-1";

  src = fetchFromGitHub {
    owner = "Cuperino";
    repo = "ClipboardInspector";
    rev = "v${version}";
    sha256 = "qzEpFZ1mW0m/zB4j0Fq/zqB1seh1IDwGOGcw3CU+z64=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt5.wrapQtAppsHook
    wrapGAppsHook
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qtquickcontrols2
    qt5.qtsvg
    libsForQt5.kirigami2
    libsForQt5.kdeFrameworks.kcoreaddons
    libsForQt5.kdeFrameworks.ki18n
    libsForQt5.kdeFrameworks.syntax-highlighting
  ];

  # Prevent double-wrapping, inject wrapper args manually instead.
  dontWrapGApps = true;
  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    homepage = "https://github.com/Cuperino/ClipboardInspector";
    description = "Native clipboard inspection app";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
