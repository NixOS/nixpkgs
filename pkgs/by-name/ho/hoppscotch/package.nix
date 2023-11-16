{ appimageTools
, fetchurl
, lib
, makeDesktopItem
}:

let
  name = "hoppscotch";
  version = "23.12.1";

  desktopItem = makeDesktopItem {
    categories = [ "Development" ];
    desktopName = "Hoppscotch";
    exec = "hoppscotch";
    icon = name;
    name = name;
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/hoppscotch/hoppscotch/20${version}/packages/hoppscotch-common/public/logo.svg";
    hash = "sha256-Njbc+RTKSOziXo0H2Mv7RyNI5CLZNkJLUr/PatyrK9E=";
  };
in
appimageTools.wrapType1 {
  inherit name version;

  src = fetchurl {
    url = "https://github.com/hoppscotch/releases/releases/download/v${version}-1/Hoppscotch_linux_x64.AppImage";
    hash = "sha256-lIfBmdyFRb+akkQkomfAyVLZnN10YoZXw/NJpNgk1/I=";
  };

  extraInstallCommands = ''
    install -D ${icon} $out/share/icons/hicolor/scalable/apps/${name}.svg

    mkdir -p $out/share/applications
    cp -r ${desktopItem} $out/share/applications/${name}.desktop
  '';

  meta = with lib; {
    description = "👽 Open-source API development ecosystem";
    longDescription = ''
      Hoppscotch is a lightweight, web-based API development suite. It was built
      from the ground up with ease of use and accessibility in mind providing
      all the functionality needed for API developers with minimalist,
      unobtrusive UI.
    '';
    homepage = "https://hoppscotch.com";
    downloadPage = "https://hoppscotch.com/downloads";
    changelog = "https://hoppscotch.com/changelog";
    license = licenses.mit;
    maintainers = with maintainers; [ getpsyched ];
    mainProgram = "hoppscotch";
    platforms = platforms.linux;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
}
