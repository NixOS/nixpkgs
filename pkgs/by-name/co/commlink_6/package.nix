{
  alsa-lib,
  autoPatchelfHook,
  cairo,
  dpkg,
  fetchurl,
  freetype,
  gdk-pixbuf,
  glib,
  gsettings-desktop-schemas,
  gtk3,
  lib,
  libGL,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxinerama,
  libxrandr,
  libxrender,
  libxtst,
  libxxf86vm,
  makeWrapper,
  pango,
  stdenv,
  versionCheckHook,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  pname = "commlink-6-updater";
  version = "1.0.3";

  src = fetchurl {
    url = "https://www.rpgframework.de/commlink6-builds/linux/Commlink6-Updater-${finalAttrs.version}.deb";
    hash = "sha256-vgdLXJv+aswEa778UC+yNKVKRgE39IFJ9lhXOLb+Hs4=";
  };

  buildInputs = [
    alsa-lib
    cairo
    freetype
    gdk-pixbuf
    glib
    gsettings-desktop-schemas
    gtk3
    libGL
    libx11
    libxcursor
    libxext
    libxi
    libxinerama
    libxrandr
    libxrender
    libxtst
    libxxf86vm
    pango
    stdenv.cc.cc.lib
    zlib
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  strictDeps = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  dontVersionCheck = true; # the resulting binary doesnt has any flags

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x $src .
    runHook postUnpack
  '';

  makeWrapperArgs = [
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    (lib.makeLibraryPath [
      stdenv.cc.cc.lib
      zlib
      freetype
      alsa-lib
      libx11
      libxext
      libxi
      libxrender
      libxtst
      libxxf86vm
      libxcursor
      libxrandr
      libxinerama
      libGL
      gtk3
      glib
      cairo
      pango
      gdk-pixbuf
    ])
    "--prefix"
    "XDG_DATA_DIRS"
    ":"
    "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}"
    "--prefix"
    "XDG_DATA_DIRS"
    ":"
    "${gtk3}/share/gsettings-schemas/${gtk3.name}"
    "--set"
    "JAVA_TOOL_OPTIONS"
    "-Dlog4j2.disableJmx=true"
    "--set"
    "JDK_JAVA_OPTIONS"
    "-Dlog4j2.disableJmx=true"
    "--add-flags"
    "-J-XX:-UseContainerSupport"
    "--add-flags"
    "-J--add-opens=java.base/java.lang=ALL-UNNAMED"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -r opt "$out/"

    mkdir -p "$out/bin"
    makeWrapper "$out/opt/commlink6-updater/bin/Commlink6 Updater" "$out/bin/commlink6-updater" "''${makeWrapperArgs[@]}"

    runHook postInstall
  '';

  meta = {
    description = "Installer and updater for Commlink 6";
    downloadPage = "https://www.rpgframework.de/commlink6-builds/linux/";
    homepage = "https://commlink.rocks/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ guelakais ];
    platforms = lib.platforms.linux;
    mainProgram = "commlink6-updater";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
