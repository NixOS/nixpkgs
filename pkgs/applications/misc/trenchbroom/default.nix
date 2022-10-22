{ lib, stdenv, fetchFromGitHub
, cmake, ninja, git, pandoc, pkg-config
, libGL, libGLU, freeimage
, catch2, fmt, glew, miniz, tinyxml-2, xorg
, qtbase, wrapQtAppsHook
, copyDesktopItems, makeDesktopItem
}:

stdenv.mkDerivation rec {
  pname = "TrenchBroom";
  version = "2022.1";

  src = fetchFromGitHub {
    owner = "TrenchBroom";
    repo = "TrenchBroom";
    rev = "v${version}";
    sha256 = "sha256-FNpYBfKnY9foPq1+21+382KKXieHksr3tCox251iJn4=";
    fetchSubmodules = true;
  };
  postPatch = ''
    substituteInPlace common/src/Version.h.in \
      --subst-var-by APP_VERSION_YEAR ${lib.versions.major version} \
      --subst-var-by APP_VERSION_NUMBER ${lib.versions.minor version} \
      --subst-var-by GIT_DESCRIBE v${version}
  '';

  nativeBuildInputs = [ cmake git pandoc wrapQtAppsHook copyDesktopItems pkg-config ];
  buildInputs = [
    libGL libGLU xorg.libXxf86vm freeimage qtbase catch2 fmt glew miniz tinyxml-2
    xorg.libSM
  ];
  QT_PLUGIN_PATH = "${qtbase}/${qtbase.qtPluginPrefix}";
  QT_QPA_PLATFORM = "offscreen";

  cmakeFlags = [
    # https://github.com/TrenchBroom/TrenchBroom/issues/4002#issuecomment-1125390780
    "-DCMAKE_PREFIX_PATH=cmake/packages"
  ];
  ninjaFlags = [
    "TrenchBroom"
  ];
  preBuild = "export HOME=$(mktemp -d)";

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
  };
}
