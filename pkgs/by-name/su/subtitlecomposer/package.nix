{
  lib,
  fetchFromGitLab,
  cmake,
  extra-cmake-modules,
  ffmpeg_6,
  openal,
  pocketsphinx,
  stdenv,
  kdePackages,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "subtitlecomposer";
  version = "0.8.2";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "multimedia";
    repo = "subtitlecomposer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zGbI960NerlOEUvhOLm+lEJdbhj8VFUfm8pkOYGRcGw=";
  };

  prePatch = ''
    # Replace KF6 monolithic find_package with individual component finds
    sed -i '/^find_package(KF\''${KF_MAJOR_VERSION}/,/WidgetsAddons)/c\
if(KF_MAJOR_VERSION EQUAL 6)\n\
	find_package(KF6Config REQUIRED)\n\
	find_package(KF6ConfigWidgets REQUIRED)\n\
	find_package(KF6CoreAddons REQUIRED)\n\
	find_package(KF6I18n REQUIRED)\n\
	find_package(KF6KIO REQUIRED)\n\
	find_package(KF6XmlGui REQUIRED)\n\
	find_package(KF6Sonnet REQUIRED)\n\
	find_package(KF6Codecs REQUIRED)\n\
	find_package(KF6TextWidgets REQUIRED)\n\
	find_package(KF6WidgetsAddons REQUIRED)\n\
else()\n\
	find_package(KF\''${KF_MAJOR_VERSION} \''${KF_MIN_VERSION} REQUIRED COMPONENTS\n\
		Config ConfigWidgets CoreAddons I18n KIO XmlGui\n\
		Sonnet Codecs TextWidgets WidgetsAddons)\n\
endif()' CMakeLists.txt

    # Remove WidgetsPrivate from the linker target since it's not available in nixpkgs
    perl -i -pe 's/Qt\$\{QT_MAJOR_VERSION\}::WidgetsPrivate\s+//g' src/CMakeLists.txt

    # Explicitly add Qt6 private include directories since Qt6Gui_PRIVATE_INCLUDE_DIRS
    # may not be populated by find_package in nixpkgs.
    # Qt's private headers require two include levels:
    #   include/QtGui/<ver>         (for <QtGui/private/...>)
    #   include/QtGui/<ver>/QtGui   (for <private/...>)
    # and similarly for QtCore and QtWidgets private headers.
    QT_PRIVATE_BASE="${qt6.qtbase}/include"
    for module in QtCore QtGui QtWidgets; do
      QT_MOD_VER=$(ls -d "$QT_PRIVATE_BASE/$module"/*/ 2>/dev/null | head -1)
      if [ -n "$QT_MOD_VER" ]; then
        sed -i "1s|^|include_directories(\"$QT_MOD_VER\" \"$QT_MOD_VER$module\")\n|" src/CMakeLists.txt
      fi
    done
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  cmakeFlags = [
    "-DQT_MAJOR_VERSION=6"
    "-DCMAKE_PREFIX_PATH=${qt6.qtbase}:${qt6.qt5compat}:${kdePackages.extra-cmake-modules}/share/ECM"
    "-DSC_WARN_ERRORS=OFF"
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  buildInputs = [
    ffmpeg_6
    openal
    pocketsphinx
    qt6.qtbase
    qt6.qt5compat
  ]
  ++ (with kdePackages; [
    kcodecs
    kconfig
    kconfigwidgets
    kcoreaddons
    ki18n
    kio
    ktextwidgets
    kwidgetsaddons
    kxmlgui
    sonnet
  ]);

  meta = {
    homepage = "https://apps.kde.org/subtitlecomposer";
    description = "Open source text-based subtitle editor";
    longDescription = ''
      An open source text-based subtitle editor that supports basic and
      advanced editing operations, aiming to become an improved version of
      Subtitle Workshop for every platform supported by Plasma Frameworks.
    '';
    changelog = "https://invent.kde.org/multimedia/subtitlecomposer/-/blob/master/ChangeLog";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ kugland ];
    mainProgram = "subtitlecomposer";
    platforms = with lib.platforms; linux ++ freebsd ++ windows;
  };
})
