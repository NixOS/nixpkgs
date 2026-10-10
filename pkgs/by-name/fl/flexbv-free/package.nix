{
  lib,
  stdenvNoCC,
  wrapGAppsHook3,
  fontconfig,
  SDL2,
  gtk3,
  glib,
  fetchurl,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "flexbv-free";
  version = "5.0687";

  src = fetchurl {
    url = "https://pldaniels.com/flexbv5/free/FlexBVFree-${finalAttrs.version}-linux.tar.gz";
    hash = "sha256-xwpRQiEvBl8RVJjgoPA93I6Fu3MDIslYAUiW3gNO5GM=";
  };

  nativeBuildInputs = [ wrapGAppsHook3 ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m 755 flexbv $out/bin/

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          fontconfig
          SDL2
          gtk3
          glib
        ]
      }
      )
  '';

  meta = {
    description = "Modern Boardview software for Win, macOS and Linux";
    homepage = "https://pldaniels.com/flexbv5/";
    license = lib.licenses.unfree;
    mainProgram = "flexbv";
    maintainers = with lib.maintainers; [ chivay ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
