{
  lib,
  fetchurl,
  autoPatchelfHook,
  jdk21,
  jdk ? jdk21,
  makeWrapper,
  stdenvNoCC,
  glib,
  gtk3,
  webkitgtk_4_1,
  gsettings-desktop-schemas,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jmc";
  version = "9.1.2";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://download.java.net/java/GA/jmc9/05/binaries/jmc-${finalAttrs.version}_linux-x64.tar.gz";
    hash = "sha256-nCUT8pMwtdjSovdvjlbzleD3+KTbxPZwFUkS/0doook=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    gtk3
    glib
    webkitgtk_4_1
    gsettings-desktop-schemas
  ];

  sourceRoot = "jmc-${finalAttrs.version}_linux-x64/JDK Mission Control";

  postUnpack = ''
    rm -rf "$sourceRoot"/plugins/com.sun.jna_*/com/sun/jna/{aix*,dragonflybsd*,freebsd*,openbsd*,sunos*,win32*}
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec/jdk-mission-control
    cp -r ./* $out/libexec/jdk-mission-control/

    mkdir -p $out/bin
    makeWrapper $out/libexec/jdk-mission-control/jmc $out/bin/jmc \
      --set JAVA_HOME "${jdk}" \
      --add-flags "-vm ${jdk}/bin" \
      --prefix PATH : "${jdk}/bin" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          gtk3
          glib
          webkitgtk_4_1
        ]
      }" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}:${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}"

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/openjdk/jmc";
    description = "Production time profiling and diagnostics tools suite for Java";
    longDescription = ''
      JDK Mission Control is an open source production time profiling and
      diagnostics tool suite for Java.
    '';
    changelog = "https://www.oracle.com/java/technologies/javase/jmc9-release-notes.html";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = lib.licenses.upl;
    mainProgram = "jmc";
    maintainers = with lib.maintainers; [ gkaganov ];
    teams = [ lib.teams.java ];
    platforms = [ "x86_64-linux" ];
  };
})
