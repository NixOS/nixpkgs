{ lib, stdenv, fetchFromGitHub
, cmake, ninja, git, pandoc
, libGL, libGLU, libXxf86vm, freeimage
, qtbase, wrapQtAppsHook
, copyDesktopItems, makeDesktopItem
}:

stdenv.mkDerivation rec {
  pname = "TrenchBroom";
  version = "2021.1";

  src = fetchFromGitHub {
    owner = "TrenchBroom";
    repo = "TrenchBroom";
    rev = "v${version}";
    sha256 = "06j68kp7g57hclyp8ilh2wd4vr5w8r718cicdp1cap48fcxlqfxv";
    fetchSubmodules = true;
  };
  postPatch = ''
    substituteInPlace common/src/Version.h.in \
      --subst-var-by APP_VERSION_YEAR ${lib.versions.major version} \
      --subst-var-by APP_VERSION_NUMBER ${lib.versions.minor version} \
      --subst-var-by GIT_DESCRIBE v${version}
  '';

  nativeBuildInputs = [ cmake git pandoc wrapQtAppsHook copyDesktopItems ];
  buildInputs = [ libGL libGLU libXxf86vm freeimage qtbase ];
  QT_PLUGIN_PATH = "${qtbase}/${qtbase.qtPluginPrefix}";
  QT_QPA_PLATFORM = "offscreen";
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
    description = "Level editor for Quake-engine based games";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ astro ];
  };
}
