{
  lib,
  stdenv,
  rpmextract,
  fetchurl,
  autoPatchelfHook,
  wrapGAppsHook3,
  desktop-file-utils,
  glib,
  gtk3,
  libayatana-appindicator,
  libdrm,
  libgbm,
  libGL,
  libheif,
  libsoup_3,
  wayland,
  webkitgtk_4_1,
  ...
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "refern";
  version = "1.8.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://storage.googleapis.com/refern-releases/releases/v${finalAttrs.version}/refern-${finalAttrs.version}-1.x86_64.rpm";
    hash = "sha256-M43SilIQTaexCW/Lhc+Lh0NII5Sarjh0SJElEQtOlZU=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    rpmextract
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    libayatana-appindicator
    libdrm
    libgbm
    libGL
    libheif
    libsoup_3
    wayland
    webkitgtk_4_1
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ desktop-file-utils ]}"
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libayatana-appindicator ]}"
    )
  '';

  unpackPhase = ''
    rpmextract "$src"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    mv usr/* "$out/"

    runHook postInstall
  '';

  meta = {
    description = "Visual reference manager";
    homepage = "https://refern.app";
    mainProgram = "refern";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      lucasoe
    ];
  };
})
