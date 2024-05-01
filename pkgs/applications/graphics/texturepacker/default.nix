{ lib
, stdenv
, fetchurl
, dpkg
, autoPatchelfHook
, wrapQtAppsHook
, qtbase
, qtdeclarative
, qtsvg
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "texturepacker";
  version = "7.3.0";

  src = fetchurl {
    url = "https://www.codeandweb.com/download/texturepacker/${finalAttrs.version}/TexturePacker-${finalAttrs.version}.deb";
    hash = "sha256-0i6LDrLBvTFKC5kW2PXP3Be6boUIJZ0fd1JG6FoS1kQ=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtdeclarative
    qtsvg
  ];

  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp usr/lib/texturepacker/{libGrantlee_Templates.so.5,libHQX.so.1.0.0,libPVRTexLib.so} $out/lib
    cp usr/lib/texturepacker/TexturePacker $out/bin
    cp -r usr/share $out
  '';

  meta = {
    changelog = "https://www.codeandweb.com/texturepacker/download";
    description = "Sprite sheet creator and game graphics optimizer";
    homepage = "https://www.codeandweb.com/texturepacker";
    license = lib.licenses.unfree;
    mainProgram = "TexturePacker";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = [ "x86_64-linux" ];
  };
})
