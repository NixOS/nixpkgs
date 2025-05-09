{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  electron,
  dpkg,
}:

stdenv.mkDerivation rec {
  pname = "scalar";
  version = "0-unstable-2025-05-04";

  src = fetchurl {
    url = "https://download.scalar.com/linux/deb/x64";
    hash = "sha256-ZziTuqCuJcgRBLeF8ipXhI1vUmzfckvaEtA5BiYuCnA=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    copyDesktopItems
  ];


  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/scalar $out/bin

    cp -r opt/Scalar/* $out/opt/scalar/

    makeWrapper ${electron}/bin/electron $out/bin/scalar \
      --add-flags "$out/opt/scalar/resources/app.asar --no-startup-window"  # Prevent startup window

    # Install all icons in their specific resolutions
    mkdir -p $out/share/icons/hicolor
    cp -r usr/share/icons/hicolor/* $out/share/icons/hicolor/

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "scalar";
      exec = "scalar %U";
      icon = "scalar";
      desktopName = "Scalar";
      genericName = "API Platform";
      categories = [
        "Development"
        "Utility"
      ];
      comment = "Modern API platform with a beautiful UI";
    })
  ];

  meta = {
    description = "Modern Rest API Client, Beautiful API References, and 1st-Class OpenAPI/Swagger Support";
    homepage = "https://scalar.com";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "scalar";
    maintainers = with lib.maintainers; [ redyf ];
  };
}
