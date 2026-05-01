{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dbus,
  gtk3,
  libdrm,
  pango,
  vulkan-loader,
  libxtst,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flexbv";
  version = "5.3127";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://pldaniels.com/flexbv5/releases/flexbv-std-${finalAttrs.version}-linux-x86_64.tar.gz";
    hash = "sha256-22KMKkWpQ84LxsnrVYYahwPSbJk2zLFLEq4feRJWWWk=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  autoPatchelfIgnoreMissingDeps = [
    "libsteam_api.so"
    "libGLES_CM.so.1"
    "libpdfium.so"
  ];

  buildInputs = [
    dbus
    gtk3
    libdrm
    pango
    vulkan-loader
    libxtst
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 flexbv $out/bin/flexbv
    install -Dm755 fbvpdf5 $out/bin/fbvpdf5

    runHook postInstall
  '';

  meta = {
    homepage = "https://pldaniels.com/flexbv5/";
    description = "Viewer for PCB layout boardview files";
    changelog = "https://pldaniels.com/flexbv5/CHANGELOG.txt";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "flexbv";
  };
})
