{
  lib,
  fetchFromGitHub,
  qt6,
  stdenv,
  cmake,
}:

let
  ads-src = fetchFromGitHub {
    owner = "githubuser0xFFFF";
    repo = "Qt-Advanced-Docking-System";
    rev = "34b68d6eab1556cf851d24e033909332771f3dfe";
    hash = "sha256-ojXH9lXs4lzhgclA8BFmyOuWy4DQE0SGK3OzuhHp000=";
  };

  qsimpleupdater-src = fetchFromGitHub {
    owner = "alex-spataru";
    repo = "QSimpleUpdater";
    rev = "8e7017f7fbdc2b4b1a26ed1eef9ebcba6a50639c";
    hash = "sha256-YU7z0U8W3s9RE41FPrWObpUOzTpqOQl4nDgyTqvnofc=";
  };

  singleapplication-src = fetchFromGitHub {
    owner = "itay-grudev";
    repo = "SingleApplication";
    rev = "494772e98cef0aa88124f154feb575cc60b08b38";
    hash = "sha256-OwfAikUJ+rC0BSLXILs0fBd1ilzu31ghMslwrgbnKhk=";
  };

  editorconfig-core-qt-src = fetchFromGitHub {
    owner = "editorconfig";
    repo = "editorconfig-core-qt";
    rev = "ab62f0554abf2bbe4d45427b36a8b2f81ca7b4ab";
    hash = "sha256-EMvkww+SWsLnjCB3gYykz0miLiSFpreoRHJpzgysX/0=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "notepad-next";
  version = "0.14";

  src = fetchFromGitHub {
    owner = "dail8859";
    repo = "NotepadNext";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XVwB8y3SrVmw0/PhvkpUDirm4QZ4ltKjDcyJOdS+1CU=";
    # External dependencies - https://github.com/dail8859/NotepadNext/issues/135
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qt5compat
  ];

  cmakeFlags = [
    "-DCPM_USE_LOCAL_PACKAGES=ON"
  ];

  postPatch = ''
    mkdir -p thirdparty/{ads,QSimpleUpdater,SingleApplication,editorconfig_core_qt}
    cp -r --no-preserve=mode ${ads-src}/* thirdparty/ads/
    cp -r --no-preserve=mode ${qsimpleupdater-src}/* thirdparty/QSimpleUpdater/
    cp -r --no-preserve=mode ${singleapplication-src}/* thirdparty/SingleApplication/
    cp -r --no-preserve=mode ${editorconfig-core-qt-src}/* thirdparty/editorconfig_core_qt/

    # Fix build with GCC 14+: Scintilla needs cstdint for intptr_t/uintptr_t types
    # https://github.com/dail8859/NotepadNext/issues/752
    substituteInPlace thirdparty/scintilla/include/ScintillaTypes.h \
      --replace-fail '#ifndef SCINTILLATYPES_H' '#ifndef SCINTILLATYPES_H
    #include <cstdint>'

    find thirdparty/ads -name "CMakeLists.txt" -exec sed -i 's/VERSION ''${VERSION_SHORT}/VERSION "4.3.1"/g' {} +

    substituteInPlace thirdparty/SingleApplication/singleapplication.cpp \
      --replace-fail '#include "singleapplication.h"' '#include <QDebug>
    #include <QMap>
    #include <QLocalSocket>
    #include "singleapplication.h"'

    substituteInPlace thirdparty/SingleApplication/singleapplication_p.h \
      --replace-fail '#ifndef SINGLEAPPLICATION_P_H' '#ifndef SINGLEAPPLICATION_P_H
    #include <QMap>
    #include <QLocalSocket>'

    echo "set(QAPPLICATION_CLASS QApplication)" > thirdparty/CMakeLists.txt
    echo "add_subdirectory(ads)" >> thirdparty/CMakeLists.txt
    echo "add_subdirectory(QSimpleUpdater)" >> thirdparty/CMakeLists.txt
    echo "add_subdirectory(SingleApplication)" >> thirdparty/CMakeLists.txt
    echo "add_subdirectory(editorconfig_core_qt)" >> thirdparty/CMakeLists.txt
    echo "add_subdirectory(lua)" >> thirdparty/CMakeLists.txt
    echo "add_subdirectory(scintilla)" >> thirdparty/CMakeLists.txt
    echo "add_subdirectory(lexilla)" >> thirdparty/CMakeLists.txt
    echo "add_subdirectory(uchardet)" >> thirdparty/CMakeLists.txt
    echo "target_link_libraries(lexilla PRIVATE scintilla)" >> thirdparty/CMakeLists.txt
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mv $out/bin $out/Applications
    rm -fr $out/share
    mkdir -p $out/bin
    ln -s $out/Applications/NotepadNext.app/Contents/MacOS/NotepadNext $out/bin/NotepadNext
  '';

  meta = with lib; {
    homepage = "https://github.com/dail8859/NotepadNext";
    description = "Cross-platform, reimplementation of Notepad++";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with lib.maintainers; [ Holiu0618 ];
    broken = stdenv.hostPlatform.isAarch64;
    mainProgram = "NotepadNext";
  };
})
