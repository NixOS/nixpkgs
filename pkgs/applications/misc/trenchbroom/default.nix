{ lib, stdenv, fetchFromGitHub, writeText
, cmake, ninja, curl, git, pandoc, pkg-config, unzip, zip
, libGL, libGLU, freeimage, freetype, assimp
, catch2, fmt, glew, miniz, tinyxml-2, xorg
, qtbase, wrapQtAppsHook
, copyDesktopItems, makeDesktopItem
}:

stdenv.mkDerivation rec {
  pname = "TrenchBroom";
  version = "2023.1";

  src = fetchFromGitHub {
    owner = "TrenchBroom";
    repo = "TrenchBroom";
    rev = "v${version}";
    sha256 = "sha256-62xcFKSqxPS+J54+kLo/hewM+Wu/rVBGD8oiECDCJpA=";
    fetchSubmodules = true;
  };
  # Manually simulate a vcpkg installation so that it can link the libraries
  # properly.
  postUnpack =
    let
      vcpkg_target = "x64-linux";

      vcpkg_pkgs = [
        "assimp"
        "catch2"
        "fmt"
        "freeimage"
        "freetype"
        "glew"
        "miniz"
        "tinyxml2"
      ];

      updates_vcpkg_file = writeText "update_vcpkg_trenchbroom" (
        lib.concatMapStringsSep "\n" (name: ''
          Package : ${name}
          Architecture : ${vcpkg_target}
          Version : 1.0
          Status : is installed
        '') vcpkg_pkgs);
    in ''
      export VCPKG_ROOT="$TMP/vcpkg"

      mkdir -p $VCPKG_ROOT/.vcpkg-root
      mkdir -p $VCPKG_ROOT/installed/${vcpkg_target}/lib
      mkdir -p $VCPKG_ROOT/installed/vcpkg/updates
      ln -s ${updates_vcpkg_file} $VCPKG_ROOT/installed/vcpkg/status
      mkdir -p $VCPKG_ROOT/installed/vcpkg/info
      ${lib.concatMapStrings (name: ''
        touch $VCPKG_ROOT/installed/vcpkg/info/${name}_1.0_${vcpkg_target}.list
      '') vcpkg_pkgs}

      ln -s ${assimp.lib}/lib/lib* $VCPKG_ROOT/installed/${vcpkg_target}/lib/
      ln -s ${catch2}/lib/lib* $VCPKG_ROOT/installed/${vcpkg_target}/lib/
      ln -s ${fmt}/lib/lib* $VCPKG_ROOT/installed/${vcpkg_target}/lib/
      ln -s ${freeimage}/lib/lib* $VCPKG_ROOT/installed/${vcpkg_target}/lib/
      ln -s ${freetype}/lib/lib* $VCPKG_ROOT/installed/${vcpkg_target}/lib/
      ln -s ${glew.out}/lib/lib* $VCPKG_ROOT/installed/${vcpkg_target}/lib/
      ln -s ${miniz}/lib/lib* $VCPKG_ROOT/installed/${vcpkg_target}/lib/
      ln -s ${tinyxml-2}/lib/lib* $VCPKG_ROOT/installed/${vcpkg_target}/lib/
    '';
  postPatch = ''
    substituteInPlace common/src/Version.h.in \
      --subst-var-by APP_VERSION_YEAR ${lib.versions.major version} \
      --subst-var-by APP_VERSION_NUMBER ${lib.versions.minor version} \
      --subst-var-by GIT_DESCRIBE v${version}
    substituteInPlace app/CMakeLists.txt \
      --replace 'set(CPACK_PACKAGING_INSTALL_PREFIX "/usr")' 'set(CPACK_PACKAGING_INSTALL_PREFIX "'$out'")'
  '';

  nativeBuildInputs = [ cmake ninja curl git pandoc wrapQtAppsHook copyDesktopItems pkg-config unzip zip ];
  buildInputs = [
    libGL libGLU xorg.libXxf86vm xorg.libSM
    freeimage freetype qtbase catch2 fmt
    glew miniz tinyxml-2 assimp
  ];
  QT_PLUGIN_PATH = "${qtbase}/${qtbase.qtPluginPrefix}";
  QT_QPA_PLATFORM = "offscreen";

  cmakeFlags = [
    "-DCMAKE_MAKE_PROGRAM=ninja"
    "-DCMAKE_TOOLCHAIN_FILE=vcpkg/scripts/buildsystems/vcpkg.cmake"
    "-DVCPKG_MANIFEST_INSTALL=OFF"
    # https://github.com/TrenchBroom/TrenchBroom/issues/4002#issuecomment-1125390780
    "-DCMAKE_PREFIX_PATH=cmake/packages"
  ];
  ninjaFlags = [
    "TrenchBroom"
  ];

  postInstall = ''
    pushd $out/share/TrenchBroom/icons

    for F in icon_*.png; do
      SIZE=$(echo $F|sed -e s/icon_// -e s/.png//)
      DIR=$out/share/icons/hicolor/$SIZE"x"$SIZE/apps
      mkdir -p $DIR
      ln -s ../../../../TrenchBroom/icons/$F $DIR/trenchbroom.png
    done

    popd
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "TrenchBroom";
      desktopName = "TrenchBroom level editor";
      icon = "trenchbroom";
      comment = meta.description;
      categories = [ "Development" ];
      exec = "trenchbroom";
    })
  ];

  meta = with lib; {
    homepage = "https://trenchbroom.github.io/";
    changelog = "https://github.com/TrenchBroom/TrenchBroom/releases/tag/v${version}";
    description = "Level editor for Quake-engine based games";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ astro ];
    platforms = [ "x86_64-linux" ];
  };
}
