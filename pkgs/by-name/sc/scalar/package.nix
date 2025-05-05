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
    hash = "sha256:05qixx9lqvw69wl1vmvfnnd3yv0hzpvsvy8h5g0i7rxcav95p2f1";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    copyDesktopItems
  ];

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb -x $src .

    runHook postUnpack
  '';

  installPhase = ''    
    runHook preInstall

    mkdir -p $out/lib/${pname} $out/bin

    cp -r opt/Scalar/* $out/lib/${pname}/

    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
    --add-flags "$out/lib/${pname}/resources/app.asar --no-startup-window"  # Prevent startup window

    # Install all icons in their specific resolutions
    mkdir -p $out/share/icons/hicolor
    cp -r usr/share/icons/hicolor/* $out/share/icons/hicolor/

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
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
    description = "Scalar - An open-source API platform: Modern Rest API Client, Beautiful API References, and 1st-Class OpenAPI/Swagger Support";
    homepage = "https://scalar.com";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = pname;
    maintainers = with lib.maintainers; [ redyf ];
  };
}
